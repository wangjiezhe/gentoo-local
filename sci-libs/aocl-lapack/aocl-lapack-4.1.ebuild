# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2
FORTRAN_NEED_OPENMP=1

DESCRIPTION="AMD optimized high-performance object-based library for DLA computations"
HOMEPAGE="https://developer.amd.com/amd-aocl/"
SRC_URI="https://github.com/amd/libflame/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libflame-${PV}"

KEYWORDS="~amd64"
LICENSE="BSD"
SLOT="0"

CPU_FLAGS=( sse3 )
IUSE_CPU_FLAGS_X86="${CPU_FLAGS[@]/#/cpu_flags_x86_}"
IUSE="eselect-ldso scc static-libs supermatrix ${IUSE_CPU_FLAGS_X86[@]}"

DEPEND="
	virtual/cblas
	sci-libs/aocl-utils
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

src_configure() {
	local myconf=(
		--includedir="${EPREFIX}"/usr/include/flame
		--disable-optimizations
		--enable-multithreading=openmp
		--enable-verbose-make-output
		--enable-lapack2flame
		--enable-cblas-interfaces
		--enable-max-arg-list-hack
		--enable-dynamic-build
		--enable-vector-intrinsics=$(usex cpu_flags_x86_sse3 sse none)
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

	if ! use static-libs; then
		find "${ED}/usr/$(get_libdir)" -name "*.a" -delete || die
	fi

	patchelf --set-soname libaocldtl.so "${ED}/usr/$(get_libdir)/libaocldtl.so" || die

	if use eselect-ldso; then
		dodir /usr/$(get_libdir)/lapack/aocl/
		dosym ../../libflame.so usr/$(get_libdir)/lapack/aocl/liblapack.so
		dosym ../../libflame.so usr/$(get_libdir)/lapack/aocl/liblapack.so.3
		dosym ../../libflame.so usr/$(get_libdir)/lapack/aocl/liblapacke.so
		dosym ../../libflame.so usr/$(get_libdir)/lapack/aocl/liblapacke.so.3
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
		elog "Current eselect: LAPACK ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: LAPACK ($libdir) -> [${current_blas}]."
		elog "To use lapack [${me}] implementation, you have to issue (as root):"
		elog "\t eselect lapack set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso && eselect lapack validate
}
