# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_PN="MapleMono"
DESCRIPTION="Open source monospace & nerd font with round corners and ligatures"
HOMEPAGE="https://github.com/subframe7536/maple-font"
SRC_URI="https://github.com/subframe7536/maple-font/releases/download/v${PV}/${MY_PN}-NF-CN-unhinted.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~mips"

BDEPEND="app-arch/unzip"

FONT_S="${S}"
FONT_SUFFIX="ttf"
