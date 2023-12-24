# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Unsupervised text tokenizer for Neural Network-based text generation"
HOMEPAGE="https://github.com/google/sentencepiece"
SRC_URI="
	https://github.com/google/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs test"
RESTRICT="!test? ( test )"
