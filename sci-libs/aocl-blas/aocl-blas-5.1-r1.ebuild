# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-any-r1 toolchain-funcs

DESCRIPTION="AMD's optimized version of BLAS targeted for AMD EPYC and Ryzen CPUs"
HOMEPAGE="https://github.com/amd/blis"
SRC_URI="https://github.com/amd/blis/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/blis-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="doc eselect-ldso index64 openmp pthread serial static-libs"
REQUIRED_USE="?? ( openmp pthread serial )"

DEPEND="
	!sci-libs/blis
	eselect-ldso? (
		!app-eselect/eselect-cblas
		>=app-eselect/eselect-blas-0.2
	)"

RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/blis-0.6.0-blas-provider.patch
	# to prevent QA Notice: pkg-config files with wrong LDFLAGS detected
	"${FILESDIR}"/${PN}-5.0-pkg-config.patch
	"${FILESDIR}"/${PN}-5.0-rpath.patch
)

src_prepare() {
	default
	if use openmp || use pthread; then
		BLIS_SUFFIX="-mt"
	else
		BLIS_SUFFIX=""
	fi
}

src_configure() {
	# This is not an autotools configure file. We don't use econf here.
	local myconf=(
		--enable-verbose-make
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		$(use_enable static-libs static)
		--enable-blas
		--enable-cblas
		--enable-shared
	)
	if use openmp; then
		myconf+=( -t openmp )
	elif use pthread; then
		myconf+=( -t pthreads )
	else
		myconf+=( -t no )
	fi
	# determine config name
	case "${ARCH}" in
		"x86" | "amd64")
			confname=auto ;;
		"ppc64")
			confname=generic ;;
		*)
			confname=generic ;;
	esac

	# confname must always come last
	myconf+=( "${confname}" )

	local -x CC="$(tc-getCC)"
	local -x AR="$(tc-getAR)"
	local -x RANLIB="$(tc-getRANLIB)"

	if use index64; then
		einfo "Configuring ILP64 variant"
		cp -r "${S}" "${S}-ilp64" || die
		pushd "${S}-ilp64" >/dev/null || die
		./configure -b 64 -i 64 "${myconf[@]}" || die
		popd >/dev/null || die
	fi

	einfo "Configuring LP64 variant"
	./configure "${myconf[@]}" || die
}

emake64() {
	local overrides=(
		LIBBLIS="libblis64${BLIS_SUFFIX}"
		MK_INCL_DIR_INST="${ED}/usr/include/blis64"
	)

	emake -C "${S}-ilp64" "${overrides[@]}" "${@}"
}

src_compile() {
	local -x DEB_LIBBLAS=libblas.so.3
	local -x DEB_LIBCBLAS=libcblas.so.3
	local -x LDS_BLAS="${FILESDIR}"/blas.lds
	local -x LDS_CBLAS="${FILESDIR}"/cblas.lds
	use index64 && emake64
	emake
}

src_test() {
	local -x LD_LIBRARY_PATH="${S}/lib/zen4"
	# emake check
	emake testblis-fast
	./testsuite/check-blistest.sh ./output.testsuite || die
	if use index64; then
		local -x LD_LIBRARY_PATH="${S}-ilp64/lib/zen4"
		emake64 testblis-fast
		./testsuite/check-blistest.sh "${S}-ilp64"/output.testsuite || die
	fi
}

src_install() {
	local libroot=/usr/$(get_libdir)
	local install_args=(
		DESTDIR="${D}"
		# remove weird Makefile configs, they're incorrect for index64
		# and nothing should be using them anyway
		MK_SHARE_DIR_INST="${T}/discard"
		# upstream installs .pc file to share, sigh
		PC_SHARE_DIR_INST="${ED}${libroot}/pkgconfig"
	)
	emake "${install_args[@]}" install
	if use index64; then
		emake64 "${install_args[@]}" install
		# we need to make blis64.pc with proper subst ourselves
		sed -e 's:blis:&64:' "${ED}${libroot}/pkgconfig/blis${BLIS_SUFFIX}.pc" \
			> "${ED}${libroot}/pkgconfig/blis64${BLIS_SUFFIX}.pc" || die
	fi
	use doc && dodoc README.md docs/*.md

	if use eselect-ldso; then
		insinto "${libroot}/blas/aocl"
		doins lib/*/lib{c,}blas.so.3
		dosym libblas.so.3 "${libroot}/blas/aocl/libblas.so"
		dosym libcblas.so.3 "${libroot}/blas/aocl/libcblas.so"
	fi
}

pkg_postinst() {
	use eselect-ldso || return

	local libdir=$(get_libdir) me="aocl"

	# check blas
	eselect blas add ${libdir} "${EROOT}"/usr/${libdir}/blas/${me} ${me}
	local current_blas=$(eselect blas show ${libdir} | cut -d' ' -f2)
	if [[ ${current_blas} == "${me}" || -z ${current_blas} ]]; then
		eselect blas set ${libdir} ${me}
		elog "Current eselect: BLAS/CBLAS (${libdir}) -> [${me}]."
	else
		elog "Current eselect: BLAS/CBLAS (${libdir}) -> [${current_blas}]."
		elog "To use blas [${me}] implementation, you have to issue (as root):"
		elog "\t eselect blas set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso && eselect blas validate
}
