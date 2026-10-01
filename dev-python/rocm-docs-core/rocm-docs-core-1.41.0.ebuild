# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Core utilities for all ROCm documentation on RTD"
HOMEPAGE="
	https://github.com/ROCm/rocm-docs-core
	https://pypi.org/project/rocm-docs-core/
"
SRC_URI="https://github.com/ROCm/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT CC-BY-4.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/gitpython[${PYTHON_USEDEP}]
	dev-python/pygithub[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/breathe[${PYTHON_USEDEP}]
	dev-python/myst-nb[${PYTHON_USEDEP}]
	dev-python/pydata-sphinx-theme[${PYTHON_USEDEP}]
	dev-python/sphinx-book-theme[${PYTHON_USEDEP}]
	dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
	dev-python/sphinx-design[${PYTHON_USEDEP}]
	dev-python/sphinx-external-toc[${PYTHON_USEDEP}]
	dev-python/sphinx-notfound-page[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/fastjsonschema[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( sphinx-markdown-builder )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Need network
	tests/test_projects.py::test_external_projects
	tests/test_projects.py::test_external_projects_invalid_value
	tests/test_projects.py::test_external_projects_unknown_project
	tests/test_llms.py
)

python_test() {
	epytest tests
}
