# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2
FORTRAN_NEED_OPENMP=1

DESCRIPTION="AMD optimized high-performance object-based library for DLA computations"
HOMEPAGE="https://developer.amd.com/amd-aocl/"
SRC_URI="https://github.com/amd/libflame/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libflame-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

CPU_FLAGS=( sse3 )
IUSE_CPU_FLAGS_X86="${CPU_FLAGS[@]/#/cpu_flags_x86_}"
IUSE="eselect-ldso scc static-libs supermatrix ${IUSE_CPU_FLAGS_X86[@]}"
RESTRICT="test"		# There are some linking issue

DEPEND="
	virtual/cblas
	sci-libs/aocl-utils[static-libs]
"
RDEPEND="
	eselect-ldso? (
		>=app-eselect/eselect-blas-0.2
		>=app-eselect/eselect-lapack-0.2
	)
"
BDEPEND="
	dev-vcs/git
	dev-util/patchelf
"

PATCHES=(
	"${FILESDIR}/${PN}-4.2-lapack-provider.patch"
)

src_configure() {
	export LIBAOCLUTILS_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)/libaoclutils.a"
	export LIBAOCLUTILS_INCLUDE_PATH="${EPREFIX}/usr/include/alci"
	export ENABLE_EMBED_AOCLUTILS=1

	## Disable cblas-interfaces to avoid redefinition error when include
	## FLAME.h together with blis.h.
	##
	## Use vector-intrinsics with cblas-interfaces disabled
	## will cause redefinition error when include FLAME.h:
	## error: typedef redefinition with different types ('union v2df_t' vs 'union v2df_t')
	local myconf=(
		--includedir="${EPREFIX}"/usr/include/flame
		--disable-optimizations
		--enable-multithreading=openmp
		--enable-verbose-make-output
		--enable-lapack2flame
		# --enable-cblas-interfaces
		--enable-max-arg-list-hack
		$(use_enable static-libs static-build)
		--enable-dynamic-build
		# --enable-vector-intrinsics=$(usex cpu_flags_x86_sse3 sse none)
		--enable-amd-flags
		--enable-amd-opt
		$(use_enable scc)
		$(use_enable supermatrix)
	)
	econf "${myconf[@]}"
}

src_install() {
	# -j1 because otherwise cannot create file that already exists
	DESTDIR="${ED}" emake -j1 install
	einstalldocs

	cat <<-EOF > flame.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include/flame

		Name: libflame
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -lflame
		Cflags: -I${includedir}/flame
	EOF

	insinto /usr/share/pkgconfig
	doins flame.pc

	patchelf --set-soname libaocldtl.so "${ED}/usr/$(get_libdir)/libaocldtl.so" || die

	if use eselect-ldso; then
		insinto /usr/$(get_libdir)/lapack/aocl/
		doins lib/*/liblapack{e,}.so.3
		dosym liblapack.so.3 usr/$(get_libdir)/lapack/aocl/liblapack.so
		dosym liblapacke.so.3 usr/$(get_libdir)/lapack/aocl/liblapacke.so
	fi
}

pkg_postinst() {
	use eselect-ldso || return

	local libdir=$(get_libdir) me="aocl"

	# check lapack
	eselect lapack add ${libdir} "${EPREFIX}"/usr/${libdir}/lapack/${me} ${me}
	local current_lapack=$(eselect lapack show ${libdir} | cut -d' ' -f2)
	if [[ ${current_lapack} == "${me}" || -z ${current_lapack} ]]; then
		eselect lapack set ${libdir} ${me}
		elog "Current eselect: LAPACK ($libdir) -> [${current_lapack}]."
	else
		elog "Current eselect: LAPACK ($libdir) -> [${current_lapack}]."
		elog "To use lapack [${me}] implementation, you have to issue (as root):"
		elog "\t eselect lapack set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso && eselect lapack validate
}
