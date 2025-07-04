# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Pytorch domain library for recommendation systems"
HOMEPAGE="https://github.com/pytorch/torchrec"
SRC_URI="https://github.com/pytorch/torchrec/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"		# need torchx

RDEPEND="
	sci-ml/torchmetrics[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/FBGEMM_GPU-0.8.0[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/iopath[${PYTHON_USEDEP}]
		dev-python/pyre-extensions[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	')
"
