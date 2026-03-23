# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Present errors that contain causes better understand what happened"
HOMEPAGE="
	https://github.com/pradyunsg/diagnostic
	https://pypi.org/project/diagnostic/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/rich
	dev-python/markdown-it-py
	dev-python/docutils
"
