# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A uniform interface to all AOCL libraries to access CPU features"
HOMEPAGE="https://github.com/amd/aocl-utils"
SRC_URI="https://github.com/amd/aocl-utils/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if ! use static-libs; then
		find "${ED}/usr/$(get_libdir)" -name "*.a" -delete || die
	fi
}
