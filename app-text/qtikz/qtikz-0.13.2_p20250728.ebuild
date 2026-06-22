# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="0a575c2246556adeecbc7b41be56e6d2e7eb6a42"

inherit qmake-utils xdg-utils

DESCRIPTION="A nice user interface for making pictures using TikZ"
HOMEPAGE="https://github.com/fhackenberger/ktikz"
SRC_URI="https://github.com/fhackenberger/ktikz/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ktikz-${EGIT_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-text/poppler[qt6]
	dev-qt/qtbase:6[gui,widgets,xml]
	dev-qt/qt5compat:6
"
RDEPEND="${DEPEND}
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-pictures
"
BDEPEND="
	dev-qt/qttools:6[assistant,linguist]
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}/${PN}-0.13.2-desktop.patch"
	"${FILESDIR}/${P}-qt6-compat.patch"
)

pkg_setup() {
	# Needed for lrelease and qhelpgenerator
	export PATH="$(qt6_get_bindir):$(qt6_get_libexecdir):${PATH}" || die
}

src_configure() {
	local myqmakeargs=(
		QCOLLECTIONGENERATORCOMMAND=qhelpgenerator
	)
	eqmake6 "${myqmakeargs[@]}"
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
