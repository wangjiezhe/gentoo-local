# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="A simple way to train and use PyTorch models with multi-GPU, TPU, mixed-precision"
HOMEPAGE="
	https://github.com/huggingface/accelerate
	https://pypi.org/project/accelerate/
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		>=sci-libs/huggingface_hub-0.21.0[${PYTHON_USEDEP}]
		>=sci-libs/safetensors-0.4.3[${PYTHON_USEDEP}]
	')
"
# BDEPEND="
# 	test? (
# 		sci-libs/pytorch-image-models[${PYTHON_SINGLE_USEDEP}]
# 		$(python_gen_cond_dep '
# 			dev-python/pytest-xdist[${PYTHON_USEDEP}]
# 			dev-python/pytest-subtests[${PYTHON_USEDEP}]
# 			dev-python/parameterized[${PYTHON_USEDEP}]
# 			sci-ml/datasets[${PYTHON_USEDEP}]
# 			sci-libs/evaluate[${PYTHON_USEDEP}]
# 			sci-ml/transformers[${PYTHON_USEDEP}]
# 			dev-python/scipy[${PYTHON_USEDEP}]
# 			sci-libs/scikit-learn[${PYTHON_USEDEP}]
# 			deepspeed
# 			dev-python/tqdm[${PYTHON_USEDEP}]
# 			bitsandbytes
# 		')
# 	)
# "

# distutils_enable_tests pytest
