# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python bindings for the docker credentials store API"
HOMEPAGE="https://github.com/shin-/dockerpy-creds"
SRC_URI="https://github.com/shin-/dockerpy-creds/archive/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

S="${WORKDIR}/dockerpy-creds-${PV}"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	app-containers/docker-credential-helpers
"
