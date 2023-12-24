# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 optfeature

DESCRIPTION="Data manipulation and transformation for audio signal processing"
HOMEPAGE="https://github.com/pytorch/text"
SRC_URI="https://github.com/pytorch/text/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/text-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	dev-libs/re2
	dev-libs/double-conversion
	dev-libs/sentencepiece
	dev-libs/libutf8proc
	>=sci-libs/pytorch-2.1.0[${PYTHON_SINGLE_USEDEP}]
	sci-libs/torchdata[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-gentoo.patch" )

src_prepare() {
	distutils-r1_src_prepare
}

pkg_postinst() {
	elog "Optional NLP tools"
	optfeature "toktok tokenizer" sci-libs/nltk
	# optfeature "SpaCy English tokenizer" sci-libs/spacy
	optfeature "NLTK port of the Moses tokenization" dev-python/sacremoses
	optfeature "revtok reversible/caps-aware tokenizer" dev-python/revtok
}
