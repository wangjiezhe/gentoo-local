# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t)
inherit python-any-r1 cmake prefix

CommitId=15f4784a3471d4db8b31720d528f2f57cd2b1f40

DESCRIPTION="part of the PyTorch Profiler"
HOMEPAGE="https://github.com/pytorch/kineto"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${CommitId}/libkineto

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

RDEPEND="
	dev-libs/libfmt
	dev-libs/dynolog
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( dev-cpp/gtest )
	${PYTHON_DEPS}
"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.0_p20250418-AppxClock.patch
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCUDA_SOURCE_DIR=/opt/cuda
		-DKINETO_BACKEND=cuda
		-DKINETO_BUILD_TESTS=OFF # tests require cuda toolkit
		-DLIBKINETO_THIRDPARTY_DIR="${EPREFIX}"/usr/include/
	)
	eapply -p2 $(prefixify_ro "${FILESDIR}"/${P}-gentoo.patch)

	cmake_src_configure
}
