# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion toolchain-funcs

DESCRIPTION="Trace any process, port, container, or file back to what started it"
HOMEPAGE="https://github.com/pranshuparmar/witr"
SRC_URI="https://github.com/pranshuparmar/witr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# SRC_URI+=" https://github.com/wangjiezhe/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
# vendored dependencies in the upstream tarball
LICENSE+=" BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips"
IUSE="abi_mips_o32 abi_mips_n64"

BDEPEND=">=dev-lang/go-1.25.0"

src_compile() {
	local ldflags=(
		-X github.com/pranshuparmar/witr/internal/version.Version=v${PV}
		-X github.com/pranshuparmar/witr/internal/version.Commit=$(gunzip < "${DISTDIR}/${P}.tar.gz" | git get-tar-commit-id | cut -c 1-7)
		-X github.com/pranshuparmar/witr/internal/version.BuildDate=$(date +%Y-%m-%d)
	)
	ego build -ldflags "${ldflags[*]}" -o ${PN} ./cmd/${PN}
}

src_test() {
	ego test ./...
}

src_install() {
	dobin ${PN}
	doman docs/cli/${PN}.1
	einstalldocs

	if ! tc-is-cross-compiler; then
		./witr completion bash > witr.bash || die
		newbashcomp witr.bash witr

		./witr completion zsh > _witr || die
		dozshcomp _witr

		./witr completion fish > witr.fish || die
		dofishcomp witr.fish
	else
		ewarn "shell completions files were skipped due to cross-compliation"
	fi
}
