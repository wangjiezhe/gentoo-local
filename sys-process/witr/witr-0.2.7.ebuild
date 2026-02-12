# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Why is this running?"
HOMEPAGE="https://github.com/pranshuparmar/witr"
SRC_URI="https://github.com/pranshuparmar/witr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/wangjiezhe/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips"
IUSE="abi_mips_o32 abi_mips_n64"

src_compile() {
	local ldflags=(
		-X main.version=${PV}
		-X main.commit=$(gunzip < "${DISTDIR}/${P}.tar.gz" | git get-tar-commit-id | cut -c 1-7)
		-X main.buildDate=$(date +%Y-%m-%d)
	)
	ego build -ldflags "${ldflags[*]}" -o ${PN} ./cmd/${PN}
}

src_install() {
	dobin ${PN}
	doman docs/cli/${PN}.1
}
