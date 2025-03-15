# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 pypi

DESCRIPTION="A PyTorch library and evaluation platform for end-to-end compression research"
HOMEPAGE="https://github.com/InterDigitalInc/CompressAI"
SRC_URI="https://github.com/InterDigitalInc/CompressAI/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/CompressAI-${PV}"

LICENSE="Clear-BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"		# Need torch_geometric

RDEPEND="
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch-msssim[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/plotly[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

python_test() {
	rm -rf compressai || die
	local EPYTEST_DESELECT=(
		## Need network
		tests/test_codec.py::TestCompressDecompress::test_image_codec
		tests/test_entropy_models.py::TestEntropyBottleneck::test_update
		tests/test_entropy_models.py::TestGaussianConditional::test_update
		tests/test_eval_model.py::test_eval_model_pretrained
		tests/test_eval_model_video.py::test_eval_model_pretrained
		tests/test_waseda.py::test_cheng2020_anchor
		tests/test_zoo.py::TestBmshj2018Factorized::test_pretrained
		tests/test_zoo.py::TestBmshj2018Hyperprior::test_pretrained
		tests/test_zoo.py::TestMbt2018Mean::test_pretrained
		tests/test_zoo.py::TestMbt2018::test_pretrained
		tests/test_zoo.py::TestCheng2020::test_pretrained
		## Permission denied: 'plot.html'
		tests/test_plot.py::test_plot
		## RuntimeError: File checkpoint.pth.tar cannot be opened.
		tests/test_train.py::test_train_example
	)
	epytest
}
