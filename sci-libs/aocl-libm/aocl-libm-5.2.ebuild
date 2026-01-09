# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Optimized libm replacement from AMD for x86_64 architectures"
HOMEPAGE="https://www.amd.com/en/developer/aocl/libm.html"
SRC_URI="https://github.com/amd/aocl-libm-ose/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/aocl-libm-ose-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"
# IUSE+=" cpu_flags_x86_avx512f"
# RESTRICT="!test? ( test )"

DEPEND="
	>=sci-libs/aocl-utils-${PV}[static-libs?]
"
# BDEPEND="
# 	test? (
# 		dev-libs/mpc
# 		dev-libs/mpfr
# 	)
# "

DOCS=( README.md docs/ReleaseNotes_AMDLibM.txt )

PATCHES=(
	"${FILESDIR}"/${P}-gcc.patch
	"${FILESDIR}"/${P}-compat.patch
)

src_prepare() {
	sed -e "s:_INSTALL_DIR}/lib:_INSTALL_DIR}/$(get_libdir):" \
			-i CMakeLists.txt src/CMakeLists.txt || die

	cmake_src_prepare

	cat <<- EOF > "${T}"/amdlibm.pc || die
		prefix=${EPREFIX}/usr
		exec_prefix=\${prefix}
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include

		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		Libs: -L\${libdir} -lalm
		Cflags: -I\${includedir}
	EOF
}

src_configure() {
	local mycmakeargs=(
		-DAOCL_UTILS_INCLUDE_DIR="${EPREFIX}"/usr/include
		-DAOCL_UTILS_LIB="${EPREFIX}"/usr/$(get_libdir)/libaoclutils.so
		# -DBUILD_STATIC_LIBS=$(usex static-libs)
		# -DLIBM_ENABLE_AVX512=$(usex cpu_flags_x86_avx512f)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/amdlibm.pc

	dosym libalm.so /usr/$(get_libdir)/libamdlibm.so
	dosym libalmfast.so /usr/$(get_libdir)/libamdlibmfast.so

	if use static-libs; then
		dosym libalm.a /usr/$(get_libdir)/libamdlibm.a
		dosym libalmfast.a /usr/$(get_libdir)/libamdlibmfast.a
	fi

	if ! use static-libs; then
		find "${ED}/usr/$(get_libdir)" -name "*.a" -delete || die
	fi
}
