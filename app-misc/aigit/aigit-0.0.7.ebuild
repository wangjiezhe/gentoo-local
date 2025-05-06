# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="The most powerful git commit assistant ever"
HOMEPAGE="https://github.com/zzxwill/aigit"
SRC_URI="https://github.com/zzxwill/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/wangjiezhe/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-vcs/git"

src_compile() {
	ego build -ldflags "-s -w -X main.Version=${PV}" -o ${PN}
}

src_install() {
	dobin ${PN}
}
