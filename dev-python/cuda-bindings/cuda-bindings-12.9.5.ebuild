# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} python3_14t )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit cuda distutils-r1 edo

DESCRIPTION="CUDA Python Low-level Bindings"
HOMEPAGE="https://github.com/NVIDIA/cuda-python"
SRC_URI="https://github.com/NVIDIA/cuda-python/archive/v${PV}.tar.gz -> cuda-python-${PV}.gh.tar.gz"

S=${WORKDIR}/cuda-python-${PV}/cuda_bindings

LICENSE="NVIDIA-CUDA-Python"
SLOT="0"
KEYWORDS="~amd64"
# RESTRICT="test"	# get <cuda.CUresult.CUDA_ERROR_OPERATING_SYSTEM: 304> while init

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="
	=dev-util/nvidia-cuda-toolkit-12*:=
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-python/cython-3.2[${PYTHON_USEDEP}]
	dev-python/pyclibrary[${PYTHON_USEDEP}]
	test? (
		dev-python/pyglet[image,${PYTHON_USEDEP}]
	)
"

QA_PRESTRIPPED=".*/site-packages/cuda/.*so"

python_prepare_all() {
	distutils-r1_python_prepare_all

	export CUDA_HOME="${EPREFIX}/opt/cuda"
	# export LIBRARY_PATH="${CUDA_HOME}/lib64:${LIBRARY_PATH}"
}

EPYTEST_PLUGINS=( numpy cuda-pathfinder )
distutils_enable_tests pytest

python_test() {
	cuda_add_sandbox -w
	rm -rf cuda || die
	local EPYTEST_IGNORE=(
		examples
		benchmarks
	)
	local EPYTEST_DESELECT=(
		# pytest-xvfb fails on WSL
		tests/test_graphics_apis.py::test_graphics_api_smoketest
	)
	edo ./tests/cython/build_tests.sh
	epytest
}
