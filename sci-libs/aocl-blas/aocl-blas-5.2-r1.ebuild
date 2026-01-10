# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AMD's optimized version of BLAS targeted for AMD EPYC and Ryzen CPUs"
HOMEPAGE="https://github.com/amd/blis"
SRC_URI="https://github.com/amd/blis/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/blis-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="index64 openmp pthread static-libs"
REQUIRED_USE="?? ( openmp pthread )"

RDEPEND="!sci-libs/blis"

DOCS=( README.md )

index64_wrapper() {
	local S="${S}-64"
	local CMAKE_USE_DIR="${S}"
	local BUILD_DIR="${BUILD_DIR}-ilp64"
	cd "${S}" || die
	"$@"
}

src_prepare() {
	sed -e 's:${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}:' \
			-e 's:${CMAKE_INSTALL_PREFIX}/include:${CMAKE_INSTALL_PREFIX}/include/blis:' \
			-i CMakeLists.txt || die

	if use index64; then
		cp -aL "${S}" "${S}-64" || die
		sed -e 's:set(LIBBLIS blis):set(LIBBLIS blis64):' \
				-e 's:${CMAKE_INSTALL_PREFIX}/include/blis:${CMAKE_INSTALL_PREFIX}/include/blis64:' \
				-e 's:set(PC_OUT_FILE "blis:set(PC_OUT_FILE "blis64:' \
				-i "${S}-64"/CMakeLists.txt || die
	fi

	cmake_src_prepare
	use index64 && index64_wrapper cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DTEST_WITH_SHARED=ON
		-DENABLE_BLAS=ON
		-DENABLE_CBLAS=ON
		-DINT_SIZE=32
		-DBLAS_INT_SIZE=32
	)

	if use openmp; then
		mycmakeargs+=( -DENABLE_THREADING=openmp )
	elif use pthread; then
		mycmakeargs+=( -DENABLE_THREADING=pthread )
	else
		mycmakeargs+=( -DENABLE_THREADING=no )
	fi

	case "${ARCH}" in
		"x86" | "amd64")
			confname=auto ;;
		"ppc64")
			confname=generic ;;
		*)
			confname=generic ;;
	esac
	mycmakeargs+=( -DBLIS_CONFIG_FAMILY=${confname} )

	cmake_src_configure

	if use index64; then
		mycmakeargs+=(
			-DINT_SIZE=64
			-DBLAS_INT_SIZE=64
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
	use index64 && index64_wrapper cmake_src_install
}
