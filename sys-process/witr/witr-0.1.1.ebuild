# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Why is this running?"
HOMEPAGE="https://github.com/pranshuparmar/witr"
SRC_URI="https://github.com/pranshuparmar/witr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips"

src_compile() {
	ego build -ldflags "-X main.version=${PV}" -o ${PN} ./cmd/${PN}
}

src_install() {
	dobin ${PN}
	doman docs/${PN}.1
}
