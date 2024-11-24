# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.22.0
	adler@1.0.2
	aho-corasick@1.1.3
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	anyhow@1.0.89
	async-stream-impl@0.3.6
	async-stream@0.3.6
	async-trait@0.1.83
	atomic-waker@1.1.2
	autocfg@1.3.0
	axum-core@0.4.5
	axum@0.7.5
	backtrace@0.3.73
	base64@0.22.1
	bitflags@2.6.0
	bumpalo@3.16.0
	byteorder@1.5.0
	bytes@1.7.1
	cc@1.1.10
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	clap@4.5.13
	clap_builder@4.5.13
	clap_derive@4.5.13
	clap_lex@0.7.2
	colorchoice@1.0.2
	core-foundation-sys@0.8.7
	core-foundation@0.10.0
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	debugid@0.8.0
	deranged@0.3.11
	either@1.13.0
	env_filter@0.1.2
	env_logger@0.11.5
	equivalent@1.0.1
	errno@0.3.9
	fastrand@2.1.1
	fixedbitset@0.4.2
	fnv@1.0.7
	form_urlencoded@1.2.1
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-io@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	getrandom@0.2.15
	gimli@0.29.0
	h2@0.4.6
	hashbrown@0.12.3
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.9
	hex@0.4.3
	hostname@0.4.0
	http-body-util@0.1.2
	http-body@1.0.1
	http@1.1.0
	httparse@1.9.4
	httpdate@1.0.3
	humantime@2.1.0
	hyper-rustls@0.27.2
	hyper-timeout@0.5.1
	hyper-util@0.1.7
	hyper@1.4.1
	ident_case@1.0.1
	idna@0.5.0
	indexmap@1.9.3
	indexmap@2.5.0
	ipnet@2.9.0
	is_terminal_polyfill@1.70.1
	itertools@0.12.1
	itoa@1.0.11
	js-sys@0.3.69
	libc@0.2.159
	libloading@0.8.5
	linux-raw-sys@0.4.14
	lock_api@0.4.12
	log@0.4.22
	matchit@0.7.3
	memchr@2.7.4
	mime@0.3.17
	miniz_oxide@0.7.4
	mio@1.0.2
	multimap@0.10.0
	nix@0.29.0
	num-conv@0.1.0
	nvml-wrapper-sys@0.8.0
	nvml-wrapper@0.10.0
	object@0.36.3
	once_cell@1.19.0
	os_info@3.8.2
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	percent-encoding@2.3.1
	petgraph@0.6.5
	pin-project-internal@1.1.5
	pin-project-lite@0.2.14
	pin-project@1.1.5
	pin-utils@0.1.0
	powerfmt@0.2.0
	ppv-lite86@0.2.20
	prettyplease@0.2.22
	proc-macro2@1.0.86
	prost-build@0.13.3
	prost-derive@0.13.3
	prost-types@0.13.3
	prost@0.13.3
	quinn-proto@0.11.8
	quinn-udp@0.5.4
	quinn@0.11.3
	quote@1.0.36
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.5.3
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.6
	reqwest@0.12.5
	ring@0.17.8
	rustc-demangle@0.1.24
	rustc-hash@2.0.0
	rustc_version@0.4.0
	rustix@0.38.37
	rustls-pemfile@2.1.3
	rustls-pki-types@1.8.0
	rustls-webpki@0.102.6
	rustls@0.22.4
	rustls@0.23.12
	rustversion@1.0.17
	ryu@1.0.18
	scopeguard@1.2.0
	semver@1.0.23
	sentry-backtrace@0.34.0
	sentry-contexts@0.34.0
	sentry-core@0.34.0
	sentry-panic@0.34.0
	sentry-tracing@0.34.0
	sentry-types@0.34.0
	sentry@0.34.0
	serde@1.0.204
	serde_derive@1.0.204
	serde_json@1.0.122
	serde_urlencoded@0.7.1
	signal-hook-registry@1.4.2
	slab@0.4.9
	smallvec@1.13.2
	socket2@0.5.7
	spin@0.9.8
	static_assertions@1.1.0
	strsim@0.11.1
	subtle@2.6.1
	syn@2.0.79
	sync_wrapper@1.0.1
	tempfile@3.13.0
	thiserror-impl@1.0.63
	thiserror@1.0.63
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	tokio-macros@2.4.0
	tokio-rustls@0.26.0
	tokio-stream@0.1.16
	tokio-util@0.7.12
	tokio@1.40.0
	tonic-build@0.12.3
	tonic-reflection@0.12.3
	tonic@0.12.3
	tower-layer@0.3.2
	tower-service@0.3.2
	tower@0.4.13
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-subscriber@0.3.18
	tracing@0.1.40
	try-lock@0.2.5
	uname@0.1.1
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	untrusted@0.9.0
	ureq@2.10.1
	url@2.5.2
	utf8parse@0.2.2
	uuid@1.10.0
	valuable@0.1.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-futures@0.4.42
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	web-sys@0.3.69
	webpki-roots@0.26.3
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows@0.52.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winreg@0.52.0
	wrapcenum-derive@0.4.1
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zeroize@1.8.1
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
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

#	sys-devel/binutils[gold]
BDEPEND="
	>=dev-lang/go-1.23.1:=
	dev-util/patchelf
"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/gitpython[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/sentry-sdk[${PYTHON_USEDEP}]
		dev-python/docker-pycreds[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/platformdirs[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/${PN}-0.18.5-hatch.patch"
	"${FILESDIR}/${PN}-0.18.5-go.patch"
)

DOC=( package_readme.md )

src_unpack() {
	S="${WORKDIR}/${P}/core" go-module_src_unpack
	S="${WORKDIR}/${P}/gpu_stats" cargo_src_unpack
}

src_prepare() {
	export CGO_LDFLAGS=$(echo "$CGO_LDFLAGS" | sed 's/-Wl,-z,pack-relative-relocs//g')
	distutils-r1_src_prepare
}
