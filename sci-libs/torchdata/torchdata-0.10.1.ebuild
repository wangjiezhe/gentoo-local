# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
# DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="A library of common modular data loading primitives"
HOMEPAGE="https://github.com/pytorch/data"
SRC_URI="https://github.com/pytorch/data/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/data-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sci-libs/pytorch-2.1.1[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/urllib3[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
RESTRICT="test"

python_prepare_all() {
	export USE_SYSTEM_LIBS=ON
	# export BUILD_S3=ON

	distutils-r1_python_prepare_all
}
