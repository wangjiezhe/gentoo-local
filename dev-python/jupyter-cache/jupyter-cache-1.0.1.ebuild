# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A defined interface for working with a cache of jupyter notebooks"
HOMEPAGE="
	https://github.com/executablebooks/jupyter-cache
	https://pypi.org/project/jupyter-cache/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/attrs
	dev-python/click
	dev-python/click-log
	dev-python/importlib-metadata
	dev-python/nbclient
	dev-python/nbformat
	dev-python/pyyaml
	dev-python/sqlalchemy
	dev-python/tabulate
"
