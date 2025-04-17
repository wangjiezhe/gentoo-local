# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYPI_NO_NORMALIZE=1
inherit distutils-r1

DESCRIPTION="Machine learning metrics for distributed, scalable PyTorch applications"
HOMEPAGE="https://github.com/Lightning-AI/torchmetrics"
SRC_URI="https://github.com/Lightning-AI/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="audio image text"

RDEPEND="
	sci-ml/lightning-utilities[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	audio? (
		sci-ml/torchaudio[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/pystoi[${PYTHON_USEDEP}]
		')
	)
	image? (
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torch-fidelity[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/scipy[${PYTHON_USEDEP}]
		')
	)
	text? (
		sci-ml/transformers[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/regex[${PYTHON_USEDEP}]
			dev-python/tqdm[${PYTHON_USEDEP}]
			sci-ml/nltk[${PYTHON_USEDEP}]
			sci-ml/pysentencepiece[${PYTHON_USEDEP}]
		')
	)
"
