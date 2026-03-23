# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A sphinx extension that allows the site-map to be defined in a single YAML file"
HOMEPAGE="
	https://github.com/executablebooks/sphinx-external-toc
	https://pypi.org/project/sphinx-external-toc/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/click
	dev-python/pyyaml
	dev-python/sphinx
	dev-python/sphinx-multitoc-numbering
"
