# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Data Distribution for NLTK"
HOMEPAGE="https://www.nltk.org/nltk_data/"
SRC_URI="
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/misc/perluniprops.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/misc/mwa_ppdb.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/stemmers/rslp.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/stemmers/porter_test.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/stemmers/snowball_data.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/chunkers/maxent_ne_chunker.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/models/moses_sample.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/models/bllip_wsj_no_aux.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/models/word2vec_sample.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/models/wmt15_eval.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/grammars/spanish_grammars.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/grammars/sample_grammars.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/grammars/large_grammars.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/grammars/book_grammars.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/grammars/basque_grammars.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/taggers/maxent_treebank_pos_tagger.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/taggers/averaged_perceptron_tagger.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/taggers/averaged_perceptron_tagger_ru.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/taggers/universal_tagset.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/sentiment/vader_lexicon.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/lin_thesaurus.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/movie_reviews.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/problem_reports.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/pros_cons.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/masc_tagged.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/sentence_polarity.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/webtext.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/nps_chat.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/city_database.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/europarl_raw.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/biocreative_ppi.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/verbnet3.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/pe08.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/pil.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/crubadan.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/gutenberg.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/propbank.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/machado.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/state_union.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/twitter_samples.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/semcor.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/wordnet31.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/extended_omw.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/names.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/ptb.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/nombank.1.0.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/floresta.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/comtrans.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/knbc.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/mac_morpho.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/swadesh.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/rte.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/toolbox.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/jeita.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/product_reviews_1.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/omw.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/wordnet2022.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/sentiwordnet.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/product_reviews_2.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/abc.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/wordnet2021.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/udhr2.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/senseval.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/words.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/framenet_v15.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/unicode_samples.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/kimmo.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/framenet_v17.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/chat80.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/qc.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/inaugural.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/wordnet.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/stopwords.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/verbnet.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/shakespeare.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/ycoe.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/ieer.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/cess_cat.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/switchboard.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/comparative_sentences.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/subjectivity.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/udhr.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/pl196x.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/paradigms.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/gazetteers.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/timit.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/treebank.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/sinica_treebank.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/opinion_lexicon.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/ppattach.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/dependency_treebank.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/reuters.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/genesis.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/cess_esp.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/conll2007.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/nonbreaking_prefixes.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/dolch.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/smultron.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/alpino.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/wordnet_ic.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/brown.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/bcp47.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/panlex_swadesh.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/conll2000.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/universal_treebanks_v20.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/brown_tei.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/cmudict.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/omw-1.4.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/mte_teip5.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/indian.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/conll2002.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/help/tagsets.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/help/tagsets_json.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/taggers/averaged_perceptron_tagger_eng.zip
	https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/taggers/averaged_perceptron_tagger_rus.zip
"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="
	sci-libs/nltk
	dev-python/six
"
BDEPEND="app-arch/unzip"
S="${WORKDIR}"

src_install() {
	for uri in ${SRC_URI}; do
		dir_name=$(echo ${uri} | cut -d/ -f8)
		data_name=$(basename -s .zip ${uri})
		insinto /usr/share/nltk_data/${dir_name}
		doins -r "${S}/${data_name}"
	done
}
