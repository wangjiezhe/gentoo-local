# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Access and share datasets for Audio, Computer Vision, and NLP tasks"
HOMEPAGE="https://pypi.org/project/datasets/"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"

RDEPEND="
	${PYTHON_DEPS}
	sci-ml/caffe2[${PYTHON_SINGLE_USEDEP},numpy]
	sci-ml/huggingface_hub[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/multiprocess[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP},parquet,snappy]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/xxhash[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="test? (
	$(python_gen_cond_dep '
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/pytest-datadir[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
	')
)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.21.0-dill.patch
)

PROPERTIES="test_network"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e \
		"/pyarrow_hotfix/d" \
		src/datasets/features/features.py || die
}

EPYTEST_IGNORE=(
		tests/packaged_modules/test_spark.py
		tests/test_load.py
		tests/features/test_video.py
)

EPYTEST_DESELECT=(
	"tests/test_arrow_dataset.py::TaskTemplatesTest::test_task_automatic_speech_recognition"
	"tests/test_distributed.py::test_torch_distributed_run"
	"tests/test_distributed.py::test_torch_distributed_run_streaming_with_num_workers"
	"tests/test_file_utils.py::TestxPath::test_xpath_glob"
	"tests/test_file_utils.py::TestxPath::test_xpath_rglob"
	"tests/test_metric_common.py::LocalMetricTest"
	"tests/features/test_audio.py::test_dataset_with_audio_feature_undecoded"
	"tests/features/test_audio.py::test_formatted_dataset_with_audio_feature_undecoded"
	"tests/features/test_audio.py::test_dataset_with_audio_feature_map_undecoded"
	"tests/packaged_modules/test_cache.py::test_cache_multi_configs"
	"tests/packaged_modules/test_cache.py::test_cache_single_config"
	"tests/test_offline_util.py::test_offline_with_timeout"
	"tests/test_hub.py::test_convert_to_parquet"

	tests/test_arrow_dataset.py::BaseDatasetTest::test_filter_caching_on_disk
	tests/test_arrow_dataset.py::BaseDatasetTest::test_map_caching_on_disk
	tests/test_fingerprint.py::RecurseHashTest::test_hash_ignores_line_definition_of_function
	tests/test_fingerprint.py::RecurseHashTest::test_hash_ipython_function
	tests/test_fingerprint.py::test_move_script_doesnt_change_hash
	tests/test_iterable_dataset.py::test_iterable_dataset_from_hub_torch_dataloader_parallel
)
