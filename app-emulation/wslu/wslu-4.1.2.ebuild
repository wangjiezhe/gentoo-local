# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="A collection of utilities for Windows Subsystem for Linux (WSL)"
HOMEPAGE="https://github.com/wslutilities/wslu"
SRC_URI="https://github.com/wslutilities/wslu/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RESTRICT="test"

RDEPEND="
	app-shells/bash-completion
	sys-devel/bc
	sys-process/psmisc
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1.1-dont-compress-manpage.patch
)

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc README.md
}

pkg_postinst() {
	optfeature "thumbnail creation" media-gfx/imagemagick
}
