# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Lightweight PyTorch wrapper for ML researchers"
HOMEPAGE="https://github.com/Lightning-AI/pytorch-lightning"
SRC_URI="https://github.com/Lightning-AI/pytorch-lightning/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/pytorch-lightning-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"		# Need fastapi, etc.

RDEPEND="
	sci-ml/lightning-utilities[${PYTHON_SINGLE_USEDEP}]
	~sci-ml/pytorch-lightning-${PV}[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-ml/torchmetrics[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
"
