# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )
inherit python-r1

DESCRIPTION="CUDA Python Low-level Bindings"
HOMEPAGE="https://github.com/NVIDIA/cuda-python"

LICENSE="NVIDIA-CUDA-Python"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/cuda-core[${PYTHON_USEDEP}]
	~dev-python/cuda-bindings-${PV}[${PYTHON_USEDEP}]
	dev-python/cuda-pathfinder[${PYTHON_USEDEP}]
"
