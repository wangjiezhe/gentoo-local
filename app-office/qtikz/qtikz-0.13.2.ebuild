# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg-utils

DESCRIPTION="A nice user interface for making pictures using TikZ"
HOMEPAGE="https://github.com/fhackenberger/ktikz"
SRC_URI="https://github.com/fhackenberger/ktikz/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ktikz-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-text/poppler[qt5]
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	dev-qt/qtxml:5
"

BDEPEND="
	dev-qt/linguist-tools:5
	dev-qt/qthelp:5
"

PATCHES=("${FILESDIR}/${P}-desktop.patch")

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	einstalldocs

	for s in 22 128; do
		insinto /usr/share/icons/hicolor/${s}x${s}/apps
		newins app/icons/qtikz-${s}.png qtikz.png
	done

	insinto /usr/share/icons/hicolor/scalable/apps
	doins app/icons/qtikz.svg
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
