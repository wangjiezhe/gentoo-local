# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake fortran-2
FORTRAN_NEED_OPENMP=1

DESCRIPTION="AMD optimized high-performance object-based library for DLA computations"
HOMEPAGE="https://developer.amd.com/amd-aocl/"
SRC_URI="https://github.com/amd/libflame/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libflame-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

CPU_FLAGS=( avx2 avx512dq )
IUSE_CPU_FLAGS_X86="${CPU_FLAGS[@]/#/cpu_flags_x86_}"
IUSE="aocl-blas gpu static-libs supermatrix ${IUSE_CPU_FLAGS_X86[@]}"
RESTRICT="test"		# There are some linking issue
REQUIRED_USE="gpu? ( supermatrix )"

DEPEND="
	virtual/cblas
	aocl-blas? ( sci-libs/aocl-blas[static-libs?] )
	sci-libs/aocl-utils[static-libs?]
"
BDEPEND="
	dev-util/patchelf
"

PATCHES=(
	"${FILESDIR}"/${P}-supermatrix.patch
)

src_prepare() {
	sed -e '/LINKER_FLAGS/s/-pie//' \
			-e 's/-march=native//' \
			-e 's/-mtune=native//' \
	    -e 's/-O3//' \
			-e 's:${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}:' \
			-e 's:${CMAKE_INSTALL_PREFIX}/include:${CMAKE_INSTALL_PREFIX}/include/flame:' \
		  -i CMakeLists.txt src/lapacke/LAPACKE/CMakeLists.txt || die
	sed -e 's:${prefix}/lib:${prefix}/@CMAKE_INSTALL_LIBDIR@:' \
			-e 's:${prefix}/include:${prefix}/include/flame:' \
			-i aocl-lapack.pc.in || die
	sed -e "/FLA_ENABLE_GPU/a\
					include_directories(${ESYSROOT}\/opt\/cuda\/include)" \
			-i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_AMD_FLAGS=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DLF_ISA_CONFIG=$(usex cpu_flags_x86_avx512dq avx512 $(usex cpu_flags_x86_avx2 avx2 none))
		-DENABLE_SUPER_MATRIX=$(usex supermatrix)
		-DENABLE_GPU=$(usex gpu)
		-DENABLE_AOCL_BLAS=$(usex aocl-blas)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	use aocl-blas || patchelf --add-needed libblas.so.3 "${ED}"/usr/$(get_libdir)/libflame.so || die "patchelf failed"
	use gpu && patchelf --add-needed libcublas.so --add-needed libcudart.so "${ED}"/usr/$(get_libdir)/libflame.so || die "patchelf failed"
}
