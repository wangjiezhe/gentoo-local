# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="A repo for data loading and utilities on PyTorch domain libraries"
HOMEPAGE="https://github.com/pytorch/data"
SRC_URI="https://github.com/pytorch/data/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"
S="${WORKDIR}"/data-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
	')
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND="${DEPEND}"
RESTRICT="test"

python_prepare_all() {
	export USE_SYSTEM_LIBS=ON
	# export BUILD_S3=ON

	distutils-r1_python_prepare_all
}
