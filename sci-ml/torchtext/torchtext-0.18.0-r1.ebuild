# Copyright 2023-2024 Gentoo Authors
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
# RESTRICT="test"

RDEPEND="
	dev-libs/re2
	dev-libs/double-conversion
	dev-libs/sentencepiece
	dev-libs/libutf8proc
	>=sci-ml/pytorch-2.2.2[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/expecttest[${PYTHON_USEDEP}]
			dev-python/hypothesis[${PYTHON_USEDEP}]
			dev-python/parameterized[${PYTHON_USEDEP}]
			dev-python/sacremoses[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.16.2-gentoo.patch" )

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

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Need network
		test/integration_tests
		test/torchtext_unittest/test_build.py::TestVocab
		test/torchtext_unittest/test_utils.py::TestUtils::test_download_extract_gz
		test/torchtext_unittest/test_utils.py::TestUtils::test_download_extract_tar
		test/torchtext_unittest/test_utils.py::TestUtils::test_download_extract_to_path
		test/torchtext_unittest/test_utils.py::TestUtils::test_download_extract_zip
		test/torchtext_unittest/prototype/test_with_asset.py::TestTransformsWithAsset::test_builtin_pretrained_sentencepiece_processor
		test/torchtext_unittest/prototype/test_with_asset.py::TestTransformsWithAsset::test_sentencepiece_with_dataloader
		# ModuleNotFoundError: No module named 'spacy'
		test/torchtext_unittest/test_build.py::TestDataUtils::test_get_tokenizer_spacy
		# Fatal Python error: Segmentation fault
		test/torchtext_unittest/prototype/test_with_asset.py::TestTransformsWithAsset::test_vocab_from_raw_text_file
	)

	rm -rf torchtext || die
	epytest
}
