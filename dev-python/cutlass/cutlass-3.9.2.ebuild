# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python packages associated with CUTLASS"
HOMEPAGE="https://github.com/NVIDIA/cutlass"
SRC_URI="https://github.com/NVIDIA/cutlass/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	dev-python/cuda-python[${PYTHON_USEDEP}]
	dev-python/scikit-build[${PYTHON_USEDEP}]
	dev-python/treelib[${PYTHON_USEDEP}]
	dev-python/pydot[${PYTHON_USEDEP}]
"
DEPEND="
	~dev-libs/cutlass-${PV}
	dev-python/pybind11[${PYTHON_USEDEP}]
"

DOCS=()

PATCHES=()
