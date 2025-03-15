# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1

CRATES="
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	heck@0.4.1
	indoc@2.0.4
	itoa@1.0.10
	libc@0.2.152
	lock_api@0.4.11
	memmap2@0.5.10
	memoffset@0.9.0
	once_cell@1.19.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	proc-macro2@1.0.78
	pyo3-build-config@0.20.2
	pyo3-ffi@0.20.2
	pyo3-macros-backend@0.20.2
	pyo3-macros@0.20.2
	pyo3@0.20.2
	quote@1.0.35
	redox_syscall@0.4.1
	ryu@1.0.16
	scopeguard@1.2.0
	serde@1.0.195
	serde_derive@1.0.195
	serde_json@1.0.111
	smallvec@1.13.1
	syn@2.0.48
	target-lexicon@0.12.13
	unicode-ident@1.0.12
	unindent@0.2.3
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
"

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 cargo

DESCRIPTION="Simple, safe way to store and distribute tensors"
HOMEPAGE="
	https://pypi.org/project/safetensors/
	https://huggingface.co/
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/lib/.*"

BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		dev-python/h5py[${PYTHON_USEDEP}]
		sci-libs/tensorflow[${PYTHON_USEDEP}]
		$(python_gen_any_dep '
			sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

S="${WORKDIR}"/${P}/bindings/python

src_prepare() {
	distutils-r1_src_prepare
}

src_configure() {
	cargo_src_configure
	distutils-r1_src_configure
}

python_compile() {
	cargo_src_compile
	distutils-r1_python_compile
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}

src_test() {
	cargo_src_test
	distutils-r1_src_test
}

python_test() {
	local EPYTEST_IGNORE=(
		# ModuleNotFoundError: No module named 'jax'
		benches/test_flax.py
		tests/test_flax_comparison.py
		# ModuleNotFoundError: No module named 'paddle'
		benches/test_paddle.py
	)
	rm -rf py_src/safetensors || die
	epytest
}
