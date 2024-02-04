# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="State-of-the-art Machine Learning for JAX, PyTorch and TensorFlow"
HOMEPAGE="
	https://pypi.org/project/transformers/
	https://huggingface.co/
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # Thousands of tests need network, especially in tests/models

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	>=sci-libs/huggingface_hub-0.19.3[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=sci-libs/safetensors-0.4.1[${PYTHON_USEDEP}]
	sci-libs/tokenizers[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"
# BDEPEND="
# 	test? (
# 		$(python_gen_any_dep '
# 			sci-libs/datasets[${PYTHON_SINGLE_USEDEP}]
# 			sci-libs/accelerate[${PYTHON_SINGLE_USEDEP}]
# 			sci-libs/evaluate[${PYTHON_SINGLE_USEDEP}]
# 		')
# 		dev-python/pytest-xdist[${PYTHON_USEDEP}]
# 		dev-python/timeout-decorator[${PYTHON_USEDEP}]
# 		dev-python/parameterized[${PYTHON_USEDEP}]
# 		dev-python/psutil[${PYTHON_USEDEP}]
# 		dev-python/pytest-timeout[${PYTHON_USEDEP}]
# 		sci-libs/nltk[${PYTHON_USEDEP}]
# 		dev-python/protobuf-python[${PYTHON_USEDEP}]
# 		dev-python/sacremoses[${PYTHON_USEDEP}]
# 		dev-python/rjieba[${PYTHON_USEDEP}]
# 		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
# 		sci-visualization/tensorboard[${PYTHON_USEDEP}]
# 		sci-libs/faiss[${PYTHON_USEDEP}]
# 	)
# "

distutils_enable_tests pytest