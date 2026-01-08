# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} python3_14t )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
inherit cuda distutils-r1

MY_PV=cuda-core-v${PV}

DESCRIPTION="CUDA Python Low-level Bindings"
HOMEPAGE="https://github.com/NVIDIA/cuda-python"
SRC_URI="https://github.com/NVIDIA/cuda-python/archive/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"

S=${WORKDIR}/cuda-python-${MY_PV}/cuda_core

LICENSE="NVIDIA-CUDA-Python"
SLOT="0"
KEYWORDS="~amd64"
# RESTRICT="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="
	dev-util/nvidia-cuda-toolkit:=
"
BDEPEND="
	${PYTHON_DEPS}
	dev-python/cython[${PYTHON_USEDEP}]
"

PARENT_PATCHES=(
	"${FILESDIR}"/${P}-test.patch
)

python_prepare_all() {
	[[ -n "${PARENT_PATCHES[*]}" ]] && eapply -p2 -- "${PARENT_PATCHES[@]}"

	distutils-r1_python_prepare_all

	export CUDA_PATH="${EPREFIX}/opt/cuda"
}

EPYTEST_PLUGINS=( numpy )
distutils_enable_tests pytest

python_test() {
	cuda_add_sandbox -w
	rm -rf cuda || die
	epytest
}
