# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{11..14} python3_14t )

inherit distutils-r1

DESCRIPTION="NCCL4Py: Python bindings for NCCL"
HOMEPAGE="
	https://github.com/NVIDIA/nccl/tree/master/bindings/nccl4py
"
SRC_URI="https://github.com/NVIDIA/nccl/archive/nccl4py-v${PV}.tar.gz -> nccl4py-${PV}.gh.tar.gz"
S="${WORKDIR}/nccl-nccl4py-v${PV}/bindings/nccl4py"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/nccl-2.30
	dev-util/nvidia-cuda-toolkit
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/cuda-core[${PYTHON_USEDEP}]
	dev-python/cuda-pathfinder[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cython-3.1
"

src_prepare() {
	distutils-r1_src_prepare
	export CUDA_HOME="${EPREFIX}/opt/cuda"
}
