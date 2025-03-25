# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PV=cuda-core-v${PV}

DESCRIPTION="CUDA Python Low-level Bindings"
HOMEPAGE="https://github.com/NVIDIA/cuda-python"
SRC_URI="https://github.com/NVIDIA/cuda-python/archive/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"

S=${WORKDIR}/cuda-python-${MY_PV}/cuda_core

LICENSE="NVIDIA-CUDA-Python"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="
	=dev-util/nvidia-cuda-toolkit-12*:=
"
BDEPEND="
	${PYTHON_DEPS}
	dev-python/cython[${PYTHON_USEDEP}]
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	export CUDA_PATH="${EPREFIX}/opt/cuda"
}
