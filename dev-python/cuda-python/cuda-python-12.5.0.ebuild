# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="CUDA Python Low-level Bindings"
HOMEPAGE="https://github.com/NVIDIA/cuda-python"
SRC_URI="https://github.com/NVIDIA/cuda-python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="NVIDIA-CUDA-Python"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="
	>=dev-util/nvidia-cuda-toolkit-12.5:=
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]
	dev-python/pyclibrary[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	export CUDA_PATH="${EPREFIX}/opt/cuda"
}

distutils_enable_tests pytest

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest
}
