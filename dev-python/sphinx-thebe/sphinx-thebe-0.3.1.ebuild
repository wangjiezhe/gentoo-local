# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Integrate interactive code blocks into your documentation with Thebe and Binder"
HOMEPAGE="
	https://github.com/executablebooks/sphinx-thebe
	https://pypi.org/project/sphinx-thebe/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/sphinx
"

EPYTEST_PLUGINS=( myst-nb sphinx-copybutton sphinx-design matplotlib pytest-{datadir,regressions} beautifulsoup4 )
distutils_enable_tests pytest
