# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Minimal effort CLIs derived from type hints and parse from command line, config files and environment variables"
HOMEPAGE="
	https://github.com/omni-us/jsonargparse/
	https://pypi.org/project/jsonargparse/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/${P}-install.patch
)

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/shtab[${PYTHON_USEDEP}]
		dev-python/argcomplete[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-subtests )
distutils_enable_tests pytest
