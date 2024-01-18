# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="Machine learning metrics for distributed, scalable PyTorch applications"
HOMEPAGE="https://github.com/Lightning-AI/torchmetrics"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="audio image text"

RDEPEND="
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	dev-python/lightning-utilities[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	audio? (
		sci-libs/torchaudio[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/pystoi[${PYTHON_USEDEP}]
		')
	)
	image? (
		sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
		sci-libs/torch-fidelity[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/scipy[${PYTHON_USEDEP}]
		')
	)
	text? (
		$(python_gen_cond_dep '
			sci-libs/nltk[${PYTHON_USEDEP}]
			sci-libs/transformers[${PYTHON_USEDEP}]
			dev-python/regex[${PYTHON_USEDEP}]
			dev-python/tqdm[${PYTHON_USEDEP}]
		')
	)
"
