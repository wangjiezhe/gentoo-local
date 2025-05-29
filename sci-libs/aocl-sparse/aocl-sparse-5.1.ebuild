# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=Release
inherit cmake

DESCRIPTION="AMD library for optimized sparse BLAS operations"
HOMEPAGE="https://developer.amd.com/amd-aocl/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/amd/aocl-sparse"
else
	SRC_URI="https://github.com/amd/aocl-sparse/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="cpu_flags_x86_avx512f examples test"
RESTRICT="!test? ( test )"

DEPEND="
	sci-libs/aocl-blas
	sci-libs/aocl-lapack
	sci-libs/aocl-utils
"

# IUSE+=" doc"
# BDEPEND="
# 	doc? (
# 		app-text/doxygen
# 		dev-python/rocm-docs-core (not packed yet)
# 		dev-python/breathe
# 		dev-python/sphinxcontrib-bibtex
# 	)
# "

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-test.patch
)

src_prepare() {
	sed -e 's/-march=native//' \
			-e 's/-mtune=native//' \
	    -e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_INSTALL_LIBDIR[[:space:]].*)/I{s/^/#_cmake_modify_IGNORE /g}' \
	    -e 's:-O3::' \
	    -i CMakeLists.txt || die
	sed -e 's:${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}:' \
	    -i library/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_UNIT_TESTS=$(usex test)
		-DUSE_AVX512=$(usex cpu_flags_x86_avx512f)
		-DAOCL_LIBFLAME_INCLUDE_DIR="${EPREFIX}"/usr/include/flame
		# -DBUILD_DOCS=$(usex doc)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use examples && dodoc -r tests/examples
}
