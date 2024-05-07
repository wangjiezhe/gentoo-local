# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
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
	sci-libs/torchmetrics[${PYTHON_SINGLE_USEDEP}]
	dev-python/FBGEMM_GPU[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tqdm[${PYTHON_USEDEP}]
	')
"
