# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.3

EAPI=8

CRATES="
	ahash@0.8.11
	aho-corasick@0.7.20
	ansi_term@0.12.1
	atty@0.2.14
	bitflags@1.3.2
	bumpalo@3.16.0
	cfg-if@1.0.0
	clap@2.34.0
	hashbrown@0.13.2
	heck@0.3.3
	heck@0.4.1
	hermit-abi@0.1.19
	itoa@1.0.11
	lazy_static@1.5.0
	libc@0.2.159
	memchr@2.7.4
	once_cell@1.20.1
	parse-js@0.20.1
	portable-atomic@1.9.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.86
	quote@1.0.37
	rustversion@1.0.17
	ryu@1.0.18
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	strsim@0.8.0
	structopt-derive@0.4.18
	structopt@0.3.26
	strum@0.24.1
	strum_macros@0.24.3
	syn@1.0.109
	syn@2.0.79
	textwrap@0.11.0
	unicode-ident@1.0.13
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	vec_map@0.8.2
	version_check@0.9.5
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo

DESCRIPTION="Extremely fast JS minifier"
HOMEPAGE="https://github.com/wilsonzlin/minify-js"
SRC_URI="
	https://github.com/wilsonzlin/minify-js/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

S="${WORKDIR}/${P}/cli"

LICENSE=""
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"

PARENT_PATCHES=(
	"${FILESDIR}/${P}-cargo.patch"
)

src_prepare() {
	cd "${WORKDIR}/${P}" || die
	[[ -n "${PARENT_PATCHES[@]}" ]] && eapply "${PARENT_PATCHES[@]}"
	eapply_user
}
