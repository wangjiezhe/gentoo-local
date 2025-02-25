# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
# notebook->argon2-cffi-bindings does not build with python3_13t
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="IPython kernel forwarding C++ cells to clang-repl"
HOMEPAGE="
	https://github.com/pmanstet/clang_repl_kernel
	https://pypi.org/project/clang-repl/
"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/ipykernel
	dev-python/pexpect
	dev-python/notebook
	dev-python/jupyter-console
"
