# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
PYPI_PN="flash_attn"
inherit cuda distutils-r1 pypi

DESCRIPTION="A library that contains a rich collection of performant PyTorch model metrics"
HOMEPAGE="https://github.com/Dao-AILab/flash-attention"
# SRC_URI="https://github.com/Dao-AILab/flash-attention/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

DEPEND="
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-ml/caffe2[cuda]
	$(python_gen_cond_dep '
		sci-ml/einops[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	app-alternatives/ninja
	$(python_gen_cond_dep '
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
"

# distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	cuda_src_prepare
	cuda_add_sandbox -w

	export FLASH_ATTENTION_FORCE_BUILD=TRUE
}
