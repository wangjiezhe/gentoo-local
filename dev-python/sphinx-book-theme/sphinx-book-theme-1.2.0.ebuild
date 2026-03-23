# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A clean book theme for scientific explanations and documentation with Sphinx"
HOMEPAGE="
	https://github.com/executablebooks/sphinx-book-theme
	https://pypi.org/project/sphinx-book-theme/
"
SRC_URI+=" https://github.com/wangjiezhe/gentoo-go-deps/releases/download/${P}/${P}-node_modules.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/sphinx
	dev-python/pydata-sphinx-theme
"
BDEPEND="
	dev-python/sphinx-theme-builder
	dev-python/nodeenv
	net-libs/nodejs[npm]
"

src_prepare() {
	NODE_VERSION=$(node --version | sed 's/^v//')
	sed -i "s/^node-version = \".\+\"$/node-version = \"${NODE_VERSION}\"/" pyproject.toml
	export STB_USE_SYSTEM_NODE=TRUE
	export npm_config_offline=true

	distutils-r1_src_prepare

	nodeenv -n system "${S}"/.nodeenv || die
	mv "${WORKDIR}"/node_modules "${S}" || die
}

EPYTEST_PLUGINS=( beautifulsoup4 coverage defusedxml myst-nb pytest-{cov,datadir,regressions} )
distutils_enable_tests pytest
