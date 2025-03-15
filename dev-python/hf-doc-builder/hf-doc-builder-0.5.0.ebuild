# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Used to build the documentation of our Hugging Face repos"
HOMEPAGE="https://github.com/huggingface/doc-builder https://pypi.org/project/hf-doc-builder/"
SRC_URI="https://github.com/huggingface/doc-builder/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/doc-builder-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/gitpython[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/gql[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		$(python_gen_any_dep 'sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]')
		sci-ml/transformers[${PYTHON_USEDEP}]
		sci-ml/tokenizers[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/${P}-test.patch" )

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		## Need network
		tests/test_autodoc.py::AutodocTester::test_resolve_links_in_text_other_docs
	)
	epytest
}
