# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="CUDA Python Low-level Bindings"
HOMEPAGE="https://github.com/NVIDIA/cuda-python"
SRC_URI="https://github.com/NVIDIA/cuda-python/archive/v${PV}.tar.gz -> cuda-python-${PV}.gh.tar.gz"

S=${WORKDIR}/cuda-python-${PV}/cuda_bindings

LICENSE="NVIDIA-CUDA-Python"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"	# get <cuda.CUresult.CUDA_ERROR_OPERATING_SYSTEM: 304> while init

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="
	=dev-util/nvidia-cuda-toolkit-12*:=
"
BDEPEND="
	${PYTHON_DEPS}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pyclibrary[${PYTHON_USEDEP}]
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	export CUDA_HOME="${EPREFIX}/opt/cuda"
	export LIBRARY_PATH="${CUDA_HOME}/lib64:${LIBRARY_PATH}"
}
