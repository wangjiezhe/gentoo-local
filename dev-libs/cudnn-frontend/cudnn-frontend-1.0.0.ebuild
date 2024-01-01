# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="A c++ wrapper for the cudnn backend API"
HOMEPAGE="https://github.com/NVIDIA/cudnn-frontend"
SRC_URI="https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/8"
KEYWORDS="~amd64"
IUSE="python"
RESTRICT="test"

RDEPEND="=dev-libs/cudnn-8*"
DEPEND="${RDEPEND}"
BDEPEND="
	python? (
		dev-python/pybind11
		dev-libs/dlpack
	)
"

PATCHES=("${FILESDIR}/${P}-cmake.patch")

src_prepare() {
	eapply_user
	use python && distutils-r1_src_prepare
}

src_configure() {
	use python && distutils-r1_src_configure
}

src_compile() {
	use python && distutils-r1_src_compile
}

src_install() {
	insinto /opt/cuda/targets/x86_64-linux
	doins -r include

	use python && distutils-r1_src_install
}
