# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="Optimized libm replacement from AMD for x86_64 architectures"
HOMEPAGE="https://www.amd.com/en/developer/aocl/libm.html"
SRC_URI="https://github.com/amd/aocl-libm-ose/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/aocl-libm-ose-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="examples static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	>=sci-libs/aocl-utils-${PV}[static-libs]
"
BDEPEND="
	test? (
		dev-libs/mpc
		dev-libs/mpfr
	)
"

DOCS=( README.md docs/ReleaseNotes_AMDLibM.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-4.2-harden.patch
	"${FILESDIR}"/${PN}-4.2-test.patch
)

src_prepare() {
	default

	## ld: warning: relocation in read-only section `.rodata'
	## ld: warning: creating DT_TEXTREL in a shared object
	## with follwing files:
	# build/aocl-release/src/isa/avx/gas/vrda_cos.o
	# build/aocl-release/src/isa/avx/gas/vrda_sin.o
	# build/aocl-release/src/isa/avx/gas/vrs4_cosf.o
	# build/aocl-release/src/isa/avx/gas/vrs4_sincosf.o
	# build/aocl-release/src/isa/avx/gas/vrs4_sinf.o
	# build/aocl-release/src/isa/avx/gas/vrsa_cosf.o
	# build/aocl-release/src/isa/avx/gas/vrsa_sincosf.o
	# build/aocl-release/src/isa/avx/gas/vrsa_sinf.o
	## However, `scanelf -qT build/aocl-release/src/libalm.so` gives：
	## scanelf: scanelf_file_textrels(): ELF build/aocl-release/src/libalm.so
	## has TEXTREL markings but doesnt appear to have any real TEXTREL's !?

	sed -e "s/^CC *=.*$/CC = $(tc-getCC)/" -i examples/Makefile || die
	sed -e "s/CC='gcc'/CC='$(tc-getCC)'/" -e "s/CC='g++'/CC='$(tc-getCXX)'/" -i \
		gtests/SConscript \
		gtests/gapi/SConscript \
		gtests/gapi/gtest/SConscript \
		gtests/gapi/gbench/SConscript || die
	sed -i -e "s| 'lib'| '$(get_libdir)'|" \
		src/SConscript \
		gtests/SConscript || die
	## Remove `-O3` and `-march=native` will fail the test!
	# sed -i -e "s/'-O3',//" \
	# 	src/*/SConscript \
	# 	src/*/*/SConscript \
	# 	gtests/*/*/SConscript || die
	# sed -i -e "s/'-march=native',//" \
	# 	src/SConscript \
	# 	gtests/SConscript \
	# 	gtests/*/SConscript \
	# 	examples/Makefile || die

	cat <<- EOF > "${T}"/amdlibm.pc || die
		prefix=${EPREFIX}/usr
		exec_prefix=\${prefix}
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include

		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		Libs: -L\${libdir} -lamdlibm
		Cflags: -I\${includedir}
	EOF
}

src_compile() {
	ECONSARGS=(
		AR="$(tc-getAR)" AS="$(tc-getAS)"
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" RANLIB="$(tc-getRANLIB)"
		--aocl_utils_install_path=/usr
		# --verbose=1
	)
	escons "${ECONSARGS[@]}"
}

src_install() {
	pushd build/aocl-release/src > /dev/null || die
	dolib.so libalm.so fast/libalmfast.so compat/libalm-glibc-compat.so
	if use static-libs;then
	  dolib.a libalm.a fast/libalmfast.a
	fi
	popd > /dev/null || die

	dosym libalm.so /usr/$(get_libdir)/libamdlibm.so
	dosym libalmfast.so /usr/$(get_libdir)/libamdlibmfast.so

	if use static-libs; then
		dosym libalm.a /usr/$(get_libdir)/libamdlibm.a
		dosym libalmfast.a /usr/$(get_libdir)/libamdlibmfast.a
	fi

	doheader include/external/*.h

	einstalldocs
	use examples && dodoc -r examples

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/amdlibm.pc
}

src_test() {
	# export SCONSOPTS="-j1"
	escons "${ECONSARGS[@]}" --verbose=1 gtests

	cd examples || die
	emake test_libm
	LD_LIBRARY_PATH="../build/aocl-release/src" ./test_libm || die
}
