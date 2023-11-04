# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit python-any-r1 cmake

CommitId=46ede25adf65de7d418240d14bc419640f8bf020

DESCRIPTION="part of the PyTorch Profiler"
HOMEPAGE="https://github.com/pytorch/kineto"
SRC_URI="
	https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz -> ${P}.tar.gz
	https://github.com/facebookincubator/dynolog/archive/refs/tags/v0.2.0.tar.gz -> dynolog-0.2.0.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-libs/libfmt
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( dev-cpp/gtest )
	${PYTHON_DEPS}
"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${PN}-0.4.0-gcc13.patch
)

src_prepare() {
	cd libkineto
	rmdir third_party/dynolog
	cp -r "${WORKDIR}"/dynolog-0.2.0 third_party/dynolog
	cmake_src_prepare
}

src_configure() {
	cd libkineto
	cmake_src_configure
}
