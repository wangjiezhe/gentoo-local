# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal toolchain-funcs

# Different date format used upstream.
RE2_VER=${PV#0.}
RE2_VER=${RE2_VER//./-}

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
SRC_URI="https://github.com/google/re2/archive/${RE2_VER}.tar.gz -> re2-${RE2_VER}.tar.gz"

S="${WORKDIR}/re2-${RE2_VER}"

LICENSE="BSD"
# NOTE: Always run libre2 through abi-compliance-checker!
# https://abi-laboratory.pro/tracker/timeline/re2/
SONAME="11"
SLOT="0/${SONAME}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~sparc ~x86"
IUSE="icu"

BDEPEND="icu? ( virtual/pkgconfig )"
DEPEND="
	>=dev-cpp/abseil-cpp-20230802
	icu? ( dev-libs/icu:0=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CONTRIBUTORS README doc/syntax.txt )
HTML_DOCS=( doc/syntax.html )

src_prepare() {
	default
	grep -q "^SONAME=${SONAME}\$" Makefile || die "SONAME mismatch"
	if use icu; then
		sed -i -e 's:^# \(\(CC\|LD\)ICU=.*\):\1:' Makefile || die
	fi
	append-cxxflags -std=c++17
	multilib_copy_sources
}

src_configure() {
	tc-export AR CXX
}

multilib_src_compile() {
	emake SONAME="${SONAME}" shared
}

multilib_src_install() {
	emake SONAME="${SONAME}" DESTDIR="${D}" prefix="${EPREFIX}/usr" libdir="\$(exec_prefix)/$(get_libdir)" shared-install
}
