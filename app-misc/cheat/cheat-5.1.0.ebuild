# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module optfeature shell-completion toolchain-funcs

DESCRIPTION="cheat allows you to create and view interactive cheatsheets on the command-line"
HOMEPAGE="https://github.com/cheat/cheat"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

# licenses present in the final built
# software. Checked with dev-go/golicense
LICENSE="MIT Apache-2.0 BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="man"

src_prepare() {
	default
	sed -i "s/^go [0-9.]\+$/go 1.25/" go.mod || die
}

src_compile() {
	ego build -o ${PN} ./cmd/${PN}
}

src_test() {
	ego test ./cmd/${PN}
}

src_install() {
	dobin ${PN}

	use man && doman doc/${PN}.1

	if ! tc-is-cross-compiler; then
		for sh in bash fish zsh; do
			"${D}"/usr/bin/${PN} --completion ${sh} > "${T}"/${PN}.${sh} || die
		done
		newbashcomp "${T}"/${PN}.bash ${PN}
		dofishcomp "${T}"/${PN}.fish
		newzshcomp "${T}"/${PN}.zsh _${PN}
	else
		ewarn "shell completions files were skipped due to cross-compliation"
	fi
}

pkg_postinst() {
	optfeature "fzf integration" app-shells/fzf
}
