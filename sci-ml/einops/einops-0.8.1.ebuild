# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi

DESCRIPTION="Flexible and powerful tensor operations for readable and reliable code"
HOMEPAGE="https://github.com/arogozhnikov/einops"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

EPYTEST_PLUGINS=( numpy )

python_test() {
	export EINOPS_TEST_BACKENDS="numpy"
	epytest
}
