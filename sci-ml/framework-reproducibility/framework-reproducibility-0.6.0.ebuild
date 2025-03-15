# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="Providing reproducibility in deep learning frameworks"
HOMEPAGE="https://github.com/NVIDIA/framework-reproducibility"
SRC_URI="https://github.com/NVIDIA/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}/${P}-install.patch"
	"${FILESDIR}/${P}-test.patch"
)

BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		sci-libs/tensorflow[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
