# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Yaegi is Another Elegant Go Interpreter"
HOMEPAGE="https://github.com/traefik/yaegi"
SRC_URI="https://github.com/traefik/yaegi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -ldflags "-X main.version=${PV}" -o ${PN} ./cmd/${PN}
}

src_install() {
	dobin ${PN}
}
