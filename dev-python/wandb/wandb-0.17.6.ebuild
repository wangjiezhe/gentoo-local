# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	bitflags@2.6.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	clap@4.5.13
	clap_builder@4.5.13
	clap_derive@4.5.13
	clap_lex@0.7.2
	colorchoice@1.0.2
	core-foundation-sys@0.8.6
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	either@1.13.0
	fnv@1.0.7
	heck@0.5.0
	ident_case@1.0.1
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	libc@0.2.155
	libloading@0.8.5
	memchr@2.7.4
	nix@0.29.0
	ntapi@0.4.1
	nvml-wrapper-sys@0.8.0
	nvml-wrapper@0.10.0
	proc-macro2@1.0.86
	quote@1.0.36
	rayon-core@1.12.1
	rayon@1.10.0
	ryu@1.0.18
	serde@1.0.204
	serde_derive@1.0.204
	serde_json@1.0.122
	signal-hook-registry@1.4.2
	signal-hook@0.3.17
	static_assertions@1.1.0
	strsim@0.11.1
	syn@2.0.72
	sysinfo@0.31.2
	thiserror-impl@1.0.63
	thiserror@1.0.63
	unicode-ident@1.0.12
	utf8parse@0.2.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.57.0
	windows-implement@0.57.0
	windows-interface@0.57.0
	windows-result@0.1.2
	windows-sys@0.52.0
	windows-targets@0.52.6
	windows@0.57.0
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	wrapcenum-derive@0.4.1
"

# dev-python/sentry-sdk does not support python3.10
PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=hatchling
inherit cargo distutils-r1 go-module

DESCRIPTION="A tool for visualizing and tracking your machine learning experiments"
HOMEPAGE="https://github.com/wandb/wandb https://wandb.ai/"
SRC_URI="
	https://github.com/wandb/wandb/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/wangjiezhe/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
LICENSE+="
	ISC MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

BDEPEND="
	>=dev-lang/go-1.22.5:=
	sys-devel/binutils[gold]
	dev-util/patchelf
"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/GitPython[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/sentry-sdk[${PYTHON_USEDEP}]
		dev-python/docker-pycreds[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/platformdirs[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/${PN}-0.17.0-hatch.patch"
	"${FILESDIR}/${PN}-0.17.6-nvidia_gpu_stats.patch"
)

DOC=( package_readme.md )

src_unpack() {
	S="${WORKDIR}/${P}/core" go-module_src_unpack
	S="${WORKDIR}/${P}/nvidia_gpu_stats" cargo_src_unpack
}

src_prepare() {
	export CGO_LDFLAGS=$(echo "$CGO_LDFLAGS" | sed 's/-Wl,-z,pack-relative-relocs//g')
	distutils-r1_src_prepare
	sed -i -e "s/@RUST_ABI@/$(rust_abi)/" "${S}"/nvidia_gpu_stats/hatch.py || die
}

src_install() {
	distutils-r1_src_install
	ldconfig -p | grep libnvidia-ml.so.1 &&
		patchelf --add-needed libnvidia-ml.so.1 "${D}/$(python_get_sitedir)"/wandb/bin/wandb-core
}
