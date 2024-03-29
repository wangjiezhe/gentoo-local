# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1 pypi

DESCRIPTION="This library implements expect tests"
HOMEPAGE="https://github.com/ezyang/expecttest"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
