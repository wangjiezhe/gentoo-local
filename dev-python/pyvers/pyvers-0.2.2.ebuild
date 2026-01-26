# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="A Python library for dynamic dispatch based on module versions and backends"
HOMEPAGE="
	https://github.com/vmoens/pyvers
	https://pypi.org/project/pyvers/
"
SRC_URI="https://github.com/vmoens/pyvers/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-cov )
EPYTEST_DESELECT=(
	# ImportError
	tests/test_numpy_jax_example.py::test_numpy_jax_example
)
distutils_enable_tests pytest
