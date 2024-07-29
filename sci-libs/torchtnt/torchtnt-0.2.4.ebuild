# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 # pypi

CommitId="077c1fe27dc32ede6b0d7e86cdd6aacf04bf6b3e"

DESCRIPTION="A lightweight library for PyTorch training tools and utilities"
HOMEPAGE="https://github.com/pytorch/tnt"
SRC_URI="https://github.com/pytorch/tnt/archive/${CommitId}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/tnt-${CommitId}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
# RESTRICT="test"

RDEPEND="
	>=sci-libs/pytorch-2.4.0[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		sci-visualization/tensorboard[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyre-extensions[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	test? (
		sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
		sci-libs/torchsnapshot[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/pytest-cov
			dev-python/typing-inspect
		')
	)
"

# PATCHES=(
# 	"${FILESDIR}/0001-Revert-fix-GradScaler-pre-commit-699.patch"
# 	"${FILESDIR}/0002-Revert-Fix-type-annotation-to-use-base-GradScaler-as.patch"
# )

# python_prepare_all() {
# 	cat <<- EOF > requirements.txt
# 	torch
# 	numpy
# 	fsspec
# 	tensorboard
# 	packaging
# 	psutil
# 	pyre_extensions
# 	typing_extensions
# 	setuptools
# 	tqdm
# 	tabulate
# 	EOF

# 	cat <<- EOF > dev-requirements.txt
# 	parameterized
# 	pytest
# 	pytest-cov
# 	torchsnapshot-nightly
# 	pyre-check
# 	torchvision
# 	EOF

# 	distutils-r1_python_prepare_all
# }

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		## Need network
		tests/utils/test_module_summary.py::ModuleSummaryTest::test_alexnet_print
		tests/utils/test_module_summary.py::ModuleSummaryTest::test_alexnet_with_input_tensor
		tests/utils/test_module_summary.py::ModuleSummaryTest::test_forward_elapsed_time
		tests/utils/test_module_summary.py::ModuleSummaryTest::test_resnet_max_depth
		## RuntimeError: TorchSnapshotSaver support requires torchsnapshot.
		## Please make sure ``torchsnapshot`` is installed.
		## Installation: https://github.com/pytorch/torchsnapshot#install
		## However, recent torchsnapshot depend on torch-2.2.0, which is at RC release now.
		tests/framework/callbacks/test_torchsnapshot_saver.py
		## RuntimeError: The local rank is larger than the number of available GPUs.
		tests/framework/test_auto_unit.py::TestAutoUnit::test_auto_unit_ddp
		tests/framework/test_auto_unit.py::TestAutoUnit::test_fsdp_fp16
		tests/framework/test_auto_unit.py::TestAutoUnit::test_no_sync
		tests/framework/test_auto_unit.py::TestAutoUnit::test_stochastic_weight_averaging_fsdp
		tests/framework/test_unit_utils.py::UnitUtilsTest::test_find_optimizers_for_FSDP_module
		tests/framework/callbacks/test_base_checkpointer.py::BaseCheckpointerTest::test_directory_sync_collective
		tests/framework/callbacks/test_dcp_saver.py::DistributedCheckpointSaverTest::test_save_restore_ddp
		tests/framework/callbacks/test_dcp_saver.py::DistributedCheckpointSaverTest::test_save_restore_fsdp
		tests/framework/callbacks/test_dcp_saver_gpu.py::DistributedCheckpointSaverGPUTest::test_save_restore_fsdp
		tests/framework/callbacks/test_progress_reporter.py::ProgressReporterTest::test_log_with_rank
		tests/framework/callbacks/test_slow_rank_detector.py::SlowRankDetectorTest::test_sync_times
		tests/framework/callbacks/test_torchsnapshot_saver_gpu.py::TorchSnapshotSaverGPUTest::test_save_restore_fsdp
		tests/framework/test_auto_unit_gpu.py::TestAutoUnitGPU::test_fsdp_fp16
		tests/framework/test_auto_unit_gpu.py::TestAutoUnitGPU::test_no_sync
		tests/framework/test_auto_unit_gpu.py::TestAutoUnitGPU::test_stochastic_weight_averaging_fsdp
		tests/framework/test_unit_utils_gpu.py::UnitUtilsGPUTest::test_find_optimizers_for_FSDP_module
		tests/utils/test_checkpoint.py::CheckpointUtilsTest::test_distributed_get_checkpoint_dirpaths
		tests/utils/test_checkpoint_gpu.py::TestCheckpointUtilsGPU::test_get_checkpoint_dirpaths_distributed
		tests/utils/test_distributed_gpu.py::DistributedGPUTest::test_gather_uneven_multidim_nccl
		tests/utils/test_distributed_gpu.py::DistributedGPUTest::test_pg_wrapper_scatter_object_list_nccl
		tests/utils/test_env.py::EnvTest::test_init_from_env_dup
		tests/utils/test_env.py::EnvTest::test_init_from_env_no_dup
		tests/utils/test_prepare_module.py::PrepareModelTest::test_fdsp_precision
		tests/utils/test_prepare_module.py::PrepareModelTest::test_fsdp_pytorch_version
		tests/utils/test_prepare_module.py::PrepareModelTest::test_prepare_ddp
		tests/utils/test_prepare_module.py::PrepareModelTest::test_prepare_fsdp
		tests/utils/test_prepare_module.py::PrepareModelTest::test_prepare_module_with_ddp
		tests/utils/test_prepare_module.py::PrepareModelTest::test_prepare_module_with_fsdp
		tests/utils/test_prepare_module_gpu.py::PrepareModelGPUTest::test_fdsp_precision
		tests/utils/test_prepare_module_gpu.py::PrepareModelGPUTest::test_prepare_ddp
		tests/utils/test_prepare_module_gpu.py::PrepareModelGPUTest::test_prepare_fsdp
		tests/utils/test_prepare_module_gpu.py::PrepareModelGPUTest::test_prepare_module_with_fsdp
		## RuntimeError: [/var/tmp/portage/sci-libs/gloo-2023.07.15-r1/work/gloo-c6f3a5bcf568dafc9a8ae482e8cc900633dd6db1/gloo/transport/tcp/pair.cc:525] Read error [127.0.0.1]:55523: Connection reset by peer
		tests/framework/callbacks/test_checkpoint_utils.py::BaseCheckpointerTest::test_directory_sync_collective
		tests/framework/callbacks/test_checkpoint_utils.py::CheckpointUtilsTest::test_distributed_get_checkpoint_dirpaths
		tests/framework/callbacks/test_checkpoint_utils.py::CheckpointUtilsTest::test_rank_zero_read_and_broadcast
		## AssertionError: 'cuda' != 'cpu'
		tests/utils/test_device.py::DeviceTest::test_get_cpu_device
	)
	epytest tests
}
