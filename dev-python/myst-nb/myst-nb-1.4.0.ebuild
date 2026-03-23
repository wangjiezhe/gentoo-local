# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A Jupyter Notebook Sphinx reader built on top of the MyST markdown parser"
HOMEPAGE="
	https://github.com/executablebooks/MyST-NB
	https://pypi.org/project/myst-nb/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/importlib-metadata
	dev-python/ipython
	dev-python/jupyter-cache
	dev-python/nbclient
	dev-python/myst-parser
	dev-python/nbformat
	dev-python/pyyaml
	dev-python/sphinx
	dev-python/typing-extensions
	dev-python/ipykernel
"
