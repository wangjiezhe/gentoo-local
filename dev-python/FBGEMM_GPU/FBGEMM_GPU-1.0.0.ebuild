# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 cuda

DESCRIPTION="A collection of high-performance PyTorch GPU operator libraries for training and inference"
HOMEPAGE="https://github.com/pytorch/FBGEMM"
SRC_URI="https://github.com/pytorch/FBGEMM/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/FBGEMM-${PV}/fbgemm_gpu"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda"
RESTRICT="test"

RDEPEND="
	>=sci-libs/pytorch-2.5[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
	')
"
DEPEND="
	dev-cpp/glog
	cuda? (
		dev-util/nvidia-cuda-toolkit
		dev-libs/cudnn
		sci-libs/caffe2:=[cuda?]
		dev-libs/nccl
	)
"
BDEPEND="
	${PYTHON_DEPS}
	dev-build/cmake
	dev-build/ninja
	$(python_gen_cond_dep '
		dev-python/scikit-build[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/setuptools-git-versioning[${PYTHON_USEDEP}]
	')
"
	# test? (
	# 	dev-python/hypothesis[${PYTHON_USEDEP}]
	# )

PARENT_PATCHES=(
	"${FILESDIR}/${P}-version.patch"
	"${FILESDIR}/${PN}-0.8.0-gentoo.patch"
)

src_prepare() {
	[[ -n "${PARENT_PATCHES[@]}" ]] && eapply -p2 -- "${PARENT_PATCHES[@]}"

	sed -i "s@CMAKE_PREFIX_PATH={torch_root}@CMAKE_PREFIX_PATH=${EPREFIX}/usr@" setup.py

	use cuda && cuda_src_prepare
	distutils-r1_src_prepare
}

python_configure_all() {
	DISTUTILS_ARGS=(
		--package_channel release
	)
	use cuda && DISTUTILS_ARGS+=(
		--nccl_lib_path "${EPREFIX}"/opt/cuda/targets/x86_64-linux/lib/libnccl.so.2
	) || DISTUTILS_ARGS+=(--package_variant cpu)
}

# distutils_enable_tests pytest

# python_test() {
# 	rm -rf fbgemm_gpu || die
# 	rm -f test/ssd_split_table_batched_embeddings_test.py || die
# 	epytest
# }
