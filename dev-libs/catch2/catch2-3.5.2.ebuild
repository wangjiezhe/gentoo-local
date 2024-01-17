# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A modern, C++-native, test framework for unit-tests, TDD and BDD"
HOMEPAGE="https://github.com/catchorg/Catch2"
SRC_URI="https://github.com/catchorg/Catch2/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/Catch2-${PV}"
