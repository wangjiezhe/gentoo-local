# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit cmake-multilib python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io/"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV%%.*}.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

BDEPEND="
	${PYTHON_DEPS}
	test? (
		>=dev-cpp/gtest-1.13.0
		sys-libs/timezone-data
	)
"

RESTRICT="!test? ( test )"
PATCHES=( "${FILESDIR}/${PN}-20230802.0-sdata-tests.patch" )

src_prepare() {
	cmake_src_prepare

	# un-hardcode abseil compiler flags
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		absl/copts/copts.py || die

	# now generate cmake files
	python_fix_shebang absl/copts/generate_copts.py
	absl/copts/generate_copts.py || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=17
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_USE_EXTERNAL_GOOGLETEST=ON
		-DABSL_PROPAGATE_CXX_STD=TRUE
		-DABSL_BUILD_TEST_HELPERS=$(usex test ON OFF)
		-DABSL_BUILD_TESTING=$(usex test ON OFF)
		$(usex test -DBUILD_TESTING=ON '') # intentional usex, it used both variables for tests.
	)

	cmake_src_configure
}