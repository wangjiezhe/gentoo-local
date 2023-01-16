# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="A collection of utilities for Windows Subsystem for Linux (WSL)"
HOMEPAGE="https://github.com/wslutilities/wslu"
SRC_URI="https://github.com/wslutilities/wslu/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}

pkg_postinst() {
	optfeature "thumbnail creation" media-gfx/imagemagick
}
