# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 pypi

DESCRIPTION="A lightweight library for PyTorch training tools and utilities"
HOMEPAGE="https://github.com/pytorch/tnt"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		sci-visualization/tensorboard[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyre-extensions[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	')
"

python_prepare_all() {
	cat <<- EOF > requirements.txt
	torch
	numpy
	fsspec
	tensorboard
	packaging
	psutil
	pyre_extensions
	typing_extensions
	setuptools
	tqdm
	tabulate
	EOF

	cat <<- EOF > dev-requirements.txt
	parameterized
	pytest
	pytest-cov
	torchsnapshot-nightly
	pyre-check
	torchvision
	EOF

	distutils-r1_python_prepare_all
}
