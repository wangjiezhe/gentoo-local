# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.10

EAPI=8

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1

CRATES="
	aho-corasick@1.1.3
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	autocfg@1.4.0
	base64@0.13.1
	bitflags@1.3.2
	bitflags@2.6.0
	bumpalo@3.16.0
	byteorder@1.5.0
	cc@1.2.1
	cfg-if@1.0.0
	colorchoice@1.0.3
	console@0.15.8
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	derive_builder@0.20.2
	derive_builder_core@0.20.2
	derive_builder_macro@0.20.2
	either@1.13.0
	encode_unicode@0.3.6
	env_filter@0.1.2
	env_logger@0.11.5
	errno@0.3.9
	esaxx-rs@0.1.10
	fastrand@2.2.0
	fnv@1.0.7
	getrandom@0.2.15
	heck@0.5.0
	humantime@2.1.0
	ident_case@1.0.1
	indicatif@0.17.9
	indoc@2.0.5
	is_terminal_polyfill@1.70.1
	itertools@0.11.0
	itertools@0.12.1
	itoa@1.0.14
	js-sys@0.3.72
	lazy_static@1.5.0
	libc@0.2.166
	linux-raw-sys@0.4.14
	log@0.4.22
	macro_rules_attribute-proc_macro@0.2.0
	macro_rules_attribute@0.2.0
	matrixmultiply@0.3.9
	memchr@2.7.4
	memoffset@0.9.1
	minimal-lexical@0.2.1
	monostate-impl@0.1.13
	monostate@0.1.13
	ndarray@0.15.6
	ndarray@0.16.1
	nom@7.1.3
	num-complex@0.4.6
	num-integer@0.1.46
	num-traits@0.2.19
	number_prefix@0.4.0
	numpy@0.22.1
	once_cell@1.20.2
	onig@6.4.0
	onig_sys@69.8.1
	paste@1.0.15
	pkg-config@0.3.31
	portable-atomic-util@0.2.4
	portable-atomic@1.10.0
	ppv-lite86@0.2.20
	proc-macro2@1.0.92
	pyo3-build-config@0.22.6
	pyo3-ffi@0.22.6
	pyo3-macros-backend@0.22.6
	pyo3-macros@0.22.6
	pyo3@0.22.6
	quote@1.0.37
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rawpointer@0.2.1
	rayon-cond@0.3.0
	rayon-core@1.12.1
	rayon@1.10.0
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-hash@1.1.0
	rustix@0.38.41
	ryu@1.0.18
	serde@1.0.215
	serde_derive@1.0.215
	serde_json@1.0.133
	shlex@1.3.0
	smallvec@1.13.2
	spm_precompiled@0.1.4
	strsim@0.11.1
	syn@2.0.89
	target-lexicon@0.12.16
	tempfile@3.14.0
	thiserror-impl@1.0.69
	thiserror@1.0.69
	unicode-ident@1.0.14
	unicode-normalization-alignments@0.1.12
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	unicode-width@0.2.0
	unicode_categories@0.1.1
	unindent@0.2.3
	utf8parse@0.2.2
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.95
	wasm-bindgen-macro-support@0.2.95
	wasm-bindgen-macro@0.2.95
	wasm-bindgen-shared@0.2.95
	wasm-bindgen@0.2.95
	web-time@1.1.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo distutils-r1

DESCRIPTION="Implementation of today's most used tokenizers"
HOMEPAGE="https://github.com/huggingface/tokenizers"
SRC_URI="
	https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

S="${WORKDIR}"/${P}/bindings/python

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 MIT Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? ( sci-ml/datasets[${PYTHON_SINGLE_USEDEP}] )
	$(python_gen_cond_dep '
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	')
"

PROPERTIES="test_network"

distutils_enable_tests pytest

QA_FLAGS_IGNORED=".*/site-packages/tokenizers/.*so"

PATCHES=( "${FILESDIR}"/${PN}-0.15.2-test.patch )

EPYTEST_IGNORE=(
	# tiktoken is not packaged yet
	benches/test_tiktoken.py
)
