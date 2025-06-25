# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYPI_NO_NORMALIZE=1
inherit distutils-r1

DESCRIPTION="View model summaries in PyTorch"
HOMEPAGE="https://github.com/TylerYep/torchinfo"
SRC_URI="https://github.com/TylerYep/torchinfo/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	test? (
		sci-ml/compressai[${PYTHON_SINGLE_USEDEP}]
		sci-ml/transformers[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/pytest-cov[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=( "${FILESDIR}/${P}-test.patch" )

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		## Need network
		tests/torchinfo_xl_test.py::test_eval_order_doesnt_matter
		tests/torchinfo_xl_test.py::test_flan_t5_small
		tests/torchinfo_xl_test.py::test_compressai
	)
	epytest
}
