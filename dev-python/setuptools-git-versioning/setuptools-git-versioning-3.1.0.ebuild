# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
# PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="Use git repo data for building a version number according PEP-440"
HOMEPAGE="https://github.com/dolfinus/setuptools-git-versioning"
# SRC_URI="https://github.com/dolfinus/setuptools-git-versioning/archive/v${PV}.tar.gz
# 	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# distutils_enable_tests pytest
