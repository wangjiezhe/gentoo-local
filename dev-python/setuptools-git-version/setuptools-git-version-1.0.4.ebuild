# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Automatically set package version from Git"
HOMEPAGE="https://github.com/pyfidelity/setuptools-git-version"
SRC_URI="https://github.com/pyfidelity/setuptools-git-version/archive/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}/${P}-test.patch" )

distutils_enable_tests pytest
