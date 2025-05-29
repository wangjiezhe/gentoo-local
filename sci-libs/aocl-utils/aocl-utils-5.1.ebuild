# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A uniform interface to all AOCL libraries to access CPU features"
HOMEPAGE="https://github.com/amd/aocl-utils"
SRC_URI="https://github.com/amd/aocl-utils/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-cpp/gtest
	)
"

DOCS=( Readme.md version.txt )

PATCHES=(
	"${FILESDIR}/${P}-install.patch"
	"${FILESDIR}/${P}-test.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DAU_BUILD_TESTS="$(usex test)"
	)

	CMAKE_BUILD_TYPE="$(usex debug DEBUG Release)"
	cmake_src_configure
}

src_install() {
	cmake_src_install

	einstalldocs

	if ! use static-libs; then
		find "${ED}/usr/$(get_libdir)" -name "*.a" -delete || die
	fi
}
