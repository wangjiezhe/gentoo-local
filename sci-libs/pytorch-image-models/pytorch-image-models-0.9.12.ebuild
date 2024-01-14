# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="PyTorch image models, scripts, pretrained weights"
HOMEPAGE="https://github.com/huggingface/pytorch-image-models"
SRC_URI="https://github.com/huggingface/pytorch-image-models/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
		sci-libs/huggingface_hub[${PYTHON_USEDEP}]
		sci-libs/safetensors[${PYTHON_USEDEP}]
	')
"

distutils_enable_tests pytest
