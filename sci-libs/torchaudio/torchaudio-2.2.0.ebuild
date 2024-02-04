# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 cuda

DESCRIPTION="Data manipulation and transformation for audio signal processing"
HOMEPAGE="https://github.com/pytorch/audio"
SRC_URI="https://github.com/pytorch/audio/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/audio-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda ffmpeg"

RDEPEND="
	>=sci-libs/pytorch-2.1.1[${PYTHON_SINGLE_USEDEP}]
	media-sound/sox
	dev-util/ccache
	ffmpeg? ( media-video/ffmpeg )
	cuda? ( >=sci-libs/caffe2-2.2.0[cuda?] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	export USE_FFMPEG=$(usex ffmpeg)
	export FFMPEG_ROOT="/usr"
	export USE_CUDA=$(usex cuda)
	export BUILD_CUDA_CTC_DECODER=$(usex cuda)

	sed -i "s/FetchContent_Populate/#FetchContent_Populate/" third_party/sox/CMakeLists.txt
	sed -i "s@/lib@/lib64@" third_party/ffmpeg/single/CMakeLists.txt

	distutils-r1_src_prepare
	use cuda && cuda_src_prepare
}

distutils_enable_tests pytest

python_test() {
	# patchelf --add-needed libsox.so /usr/lib64/sox/*
	local EPYTEST_IGNORE=(
		# ModuleNotFoundError: No module named 'librosa'
		test/torchaudio_unittest/prototype/hifi_gan/hifi_gan_cpu_test.py
		test/torchaudio_unittest/prototype/hifi_gan/hifi_gan_gpu_test.py
	)
	local _EPYTEST_DESELECT=(
		# Need network
		test/integration_tests
		# requires module: kaldi_io
		test/torchaudio_unittest/kaldi_io_test.py
		# too slow (5min)
		# test/torchaudio_unittest/backend/dispatcher/ffmpeg/load_test.py::TestLoad::test_vorbis_large_16000_2_10
		# ModuleNotFoundError: No module named 'soundfile'
		test/torchaudio_unittest/backend/dispatcher/soundfile/
		test/torchaudio_unittest/backend/soundfile/
		# RuntimeError: Error loading audio file
		test/torchaudio_unittest/backend/sox_io/info_test.py::TestInfo::test_mp3
		test/torchaudio_unittest/backend/sox_io/info_test.py::TestLoadWithoutExtension::test_mp3
		test/torchaudio_unittest/backend/sox_io/load_test.py::TestLoadWithoutExtension::test_mp3
		test/torchaudio_unittest/backend/sox_io/smoke_test.py::SmokeTest::test_mp3
		test/torchaudio_unittest/functional/functional_cpu_test.py::TestApplyCodec::test_mp3
		# RuntimeError: Failed to create the filter from "scale_cuda=format=yuv444p" (Filter not found.)
		# test/torchaudio_unittest/io/stream_reader_test.py::FilterGraphWithCudaAccel::test_scale_cuda_format
		# RuntimeError: Failed to create the filter from "scale_cuda=iw/2:ih/2" (Invalid argument.)
		# test/torchaudio_unittest/io/stream_reader_test.py::FilterGraphWithCudaAccel::test_sclae_cuda_change_size
		# AssertionError
		# assert high > 1 while high = 1
		test/torchaudio_unittest/prototype/conformer_wav2vec2_test.py::TestConformerWav2Vec2::test_pretrain_cuda_smoke_test__function_conformer_wav2vec2_pretrain_base_at_0x7fe8bda16ac0__torch_float32
		test/torchaudio_unittest/prototype/conformer_wav2vec2_test.py::TestConformerWav2Vec2::test_pretrain_cuda_smoke_test__function_conformer_wav2vec2_pretrain_base_at_0x7fe8bda16ac0__torch_float64
		# RuntimeError: Caught RuntimeError in DataLoader worker process 0. (randomly??)
		test/torchaudio_unittest/sox_effect/dataset_test.py::TestSoxEffectsDataset::test_apply_effects_file
		test/torchaudio_unittest/sox_effect/dataset_test.py::TestSoxEffectsDataset::test_apply_effects_tensor
		# AssertionError: Tensor-likes are not close!
		test/torchaudio_unittest/transforms/batch_consistency_test.py::TestTransforms::test_batch_inverse_spectrogram
		test/torchaudio_unittest/transforms/batch_consistency_test.py::TestTransforms::test_batch_pitch_shift
		test/torchaudio_unittest/transforms/batch_consistency_test.py::TestTransforms::test_batch_spectrogram
	)
	epytest
}
