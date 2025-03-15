# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYPI_NO_NORMALIZE=1
inherit distutils-r1

DESCRIPTION="A library that contains a rich collection of performant PyTorch model metrics"
HOMEPAGE="https://github.com/pytorch/torcheval"
SRC_URI="https://github.com/pytorch/torcheval/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	>=sci-ml/torchtnt-0.0.5[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
"
# BDEPEND="
# 	test? (
# 		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
# 		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
# 		dev-python/numpy[${PYTHON_USEDEP}]
# 		sci-libs/scikit-learn[${PYTHON_USEDEP}]
# 	)
# "

# distutils_enable_tests pytest
