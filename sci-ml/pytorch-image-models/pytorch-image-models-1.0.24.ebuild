# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=pdm-backend
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="PyTorch image models, scripts, pretrained weights"
HOMEPAGE="https://github.com/huggingface/pytorch-image-models"
SRC_URI="https://github.com/huggingface/pytorch-image-models/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
# RESTRICT="test"		# some tests fail randomly

RDEPEND="
	sci-ml/huggingface_hub[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
		sci-ml/safetensors[${PYTHON_USEDEP}]
	')
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# timeout (>120s)
	"tests/test_models.py::test_model_backward[2-efficientnet_l2]"
	"tests/test_models.py::test_model_backward[2-mvitv2_huge_cls]"
	"tests/test_models.py::test_model_backward[2-mvitv2_large]"
	"tests/test_models.py::test_model_backward[2-tf_efficientnet_l2]"
	"tests/test_models.py::test_model_backward_fx[2-mvitv2_huge_cls]"
	# assert 16 == 42
	"tests/test_models.py::test_model_backward_fx[2-mobilenetv5_300m_enc]"
	# need network
	tests/test_models.py::test_model_inference
	tests/test_models.py::test_model_load_pretrained
	tests/test_models.py::test_model_features_pretrained
)
