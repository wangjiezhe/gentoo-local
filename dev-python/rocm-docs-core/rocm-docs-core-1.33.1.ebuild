# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

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
	dev-python/gitpython
	dev-python/pygithub
	dev-python/sphinx
	dev-python/breathe
	dev-python/myst-nb
	dev-python/pydata-sphinx-theme
	dev-python/sphinx-book-theme
	dev-python/sphinx-copybutton
	dev-python/sphinx-design
	dev-python/sphinx-external-toc
	dev-python/sphinx-notfound-page
	dev-python/pyyaml
	dev-python/fastjsonschema
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Need network
	tests/test_projects.py::test_external_projects
	tests/test_projects.py::test_external_projects_invalid_value
	tests/test_projects.py::test_external_projects_unknown_project
)

python_test() {
	epytest tests
}
