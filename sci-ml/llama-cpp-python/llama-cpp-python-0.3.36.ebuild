# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_EXT=1

inherit cuda distutils-r1

DESCRIPTION="Python bindings for the llama.cpp library"
HOMEPAGE="
	https://github.com/abetlen/llama-cpp-python
	https://pypi.org/project/llama-cpp-python/
"
SRC_URI="https://github.com/abetlen/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/diskcache[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	>=sci-ml/llama-cpp-0.5.0
"

src_prepare() {
	eapply -R "${FILESDIR}"/${P}-2375.patch
	distutils-r1_src_prepare
}

python_compile() {
	local mycmakeargs=(
		-DLLAMA_BUILD=OFF
	)

	CMAKE_ARGS="${mycmakeargs[@]}" distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all

	dodir /etc/env.d
	echo "LLAMA_CPP_LIB_PATH=/usr/$(get_libdir)" > "${ED}/etc/env.d/99llama-cpp"
}
