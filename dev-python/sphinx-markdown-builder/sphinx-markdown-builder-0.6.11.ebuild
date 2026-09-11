# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="A Sphinx extension to add markdown generation support"
HOMEPAGE="
	https://github.com/liran-funaro/sphinx-markdown-builder
	https://pypi.org/project/sphinx-markdown-builder/
"
SRC_URI="https://github.com/liran-funaro/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-python/sphinx
"

RDEPEND="
	dev-python/tabulate
	dev-python/docutils
"

EPYTEST_PLUGINS=( pytest-cov sphinxcontrib-httpdomain )
distutils_enable_tests pytest
