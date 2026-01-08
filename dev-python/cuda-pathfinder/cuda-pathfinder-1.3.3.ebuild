# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} python3_14t )

inherit distutils-r1

DESCRIPTION="Pathfinder for CUDA components"
HOMEPAGE="
	https://github.com/NVIDIA/cuda-python/tree/main/cuda_pathfinder/
	https://pypi.org/project/cuda-pathfinder/
"
SRC_URI="https://github.com/NVIDIA/cuda-python/archive/${PN}-v${PV}.tar.gz -> ${P}.gh.tar.gz"

S=${WORKDIR}/cuda-python-${PN}-v${PV}/cuda_pathfinder

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
