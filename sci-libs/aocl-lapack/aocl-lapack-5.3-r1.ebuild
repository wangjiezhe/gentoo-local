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
IUSE="aocl-blas index64 gpu openmp static-libs supermatrix ${IUSE_CPU_FLAGS_X86[@]}"
RESTRICT="test"		# There are some linking issue
REQUIRED_USE="gpu? ( supermatrix )"

DEPEND="
	virtual/cblas
	aocl-blas? ( sci-libs/aocl-blas[static-libs?,openmp?,index64?] )
	sci-libs/aocl-utils[static-libs?]
	gpu? ( =dev-util/nvidia-cuda-toolkit-12* )
"
BDEPEND="
	dev-util/patchelf
"

PATCHES=(
	"${FILESDIR}"/${P}-supermatrix.patch
)

index64_wrapper() {
	local S="${S}-64"
	local CMAKE_USE_DIR="${S}"
	local BUILD_DIR="${BUILD_DIR}-ilp64"
	cd "${S}" || die
	"$@"
}

src_prepare() {
	sed -e '/LINKER_FLAGS/s/-pie//' \
			-e 's/-march=native//' \
			-e 's/-mtune=native//' \
	    -e 's/-O3//' \
			-i cmake/CompilerFlags.cmake || die
	sed -e 's:${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}:' \
			-e 's:\(${CMAKE_INSTALL_PREFIX}/include\):\1/flame:' \
		  -i CMakeLists.txt src/lapacke/LAPACKE/CMakeLists.txt || die
	sed -e 's:${prefix}/lib:${prefix}/@CMAKE_INSTALL_LIBDIR@:' \
			-e 's:\(${prefix}/include\):\1/flame:' \
			-i aocl-lapack.pc.in || die
	sed -e "/FLA_ENABLE_GPU/a\
					include_directories(${ESYSROOT}\/opt\/cuda\/include)" \
			-i CMakeLists.txt || die

	if use index64; then
		cp -aL "${S}" "${S}-64" || die
		sed -e 's:\(${CMAKE_INSTALL_PREFIX}/include/flame\):\164:' \
				-e 's:\(set(REQ_BLAS_PKGNAME "blis\):\164:' \
				-e 's:flame.pc:flame64.pc:' \
				-e 's:\(project(flame\):\164:' \
				-i "${S}-64"/CMakeLists.txt "${S}-64"/src/lapacke/LAPACKE/CMakeLists.txt || die
		sed -e 's:\(${prefix}/include/flame\):\164:' \
				-i "${S}-64"/aocl-lapack.pc.in || die
	fi

	cmake_src_prepare
	use index64 && index64_wrapper cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_AMD_FLAGS=ON
		-DENABLE_MULTITHREADING=$(usex openmp)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DLF_ISA_CONFIG=$(usex cpu_flags_x86_avx512dq avx512 $(usex cpu_flags_x86_avx2 avx2 none))
		-DENABLE_SUPER_MATRIX=$(usex supermatrix)
		-DENABLE_GPU=$(usex gpu)
		-DENABLE_AOCL_BLAS=$(usex aocl-blas)
	)
	cmake_src_configure

	if use index64; then
		mycmakeargs+=(
			-DENABLE_ILP64=ON
			-DBUILD_INDEX64=ON
		)
		index64_wrapper cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile
	use index64 && index64_wrapper cmake_src_compile
}

src_install() {
	cmake_src_install

	use aocl-blas || patchelf --add-needed libblas.so.3 "${ED}"/usr/$(get_libdir)/libflame.so || die "patchelf failed"
	use gpu && patchelf --add-needed libcublas.so.12  --add-needed libcudart.so.12 "${ED}"/usr/$(get_libdir)/libflame.so || die "patchelf failed"

	if use index64; then
		index64_wrapper cmake_src_install

		use aocl-blas || patchelf --add-needed libblas.so.3  "${ED}"/usr/$(get_libdir)/libflame64.so || die "patchelf failed"

		use gpu && patchelf --add-needed libcublas.so.12 --add-needed libcudart.so.12 "${ED}"/usr/$(get_libdir)/libflame64.so || die "patchelf failed"
	fi
}
