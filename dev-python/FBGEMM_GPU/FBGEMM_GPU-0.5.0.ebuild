# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 cuda

DESCRIPTION="A collection of high-performance PyTorch GPU operator libraries for training and inference"
HOMEPAGE="https://github.com/pytorch/FBGEMM"
SRC_URI="https://github.com/pytorch/FBGEMM/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda"
RESTRICT="test"

S="${WORKDIR}/FBGEMM-${PV}/fbgemm_gpu"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="
	cuda? (
		dev-util/nvidia-cuda-toolkit
		dev-libs/cudnn
	)
"
BDEPEND="
	${PYTHON_DEPS}
	dev-build/cmake
	dev-build/ninja
	dev-python/scikit-build[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
"
	# test? (
	# 	dev-python/hypothesis[${PYTHON_USEDEP}]
	# )

PARENT_PATCHES=( "${FILESDIR}/${P}-version.patch" )

src_prepare() {
	[[ -n "${PARENT_PATCHES[@]}" ]] && eapply -p2 -- "${PARENT_PATCHES[@]}"
	use cuda && cuda_src_prepare
	distutils-r1_src_prepare
}

python_configure_all() {
		use cuda || DISTUTILS_ARGS=(
			--cpu_only
		)
}

# distutils_enable_tests pytest

# python_test() {
# 	rm -rf fbgemm_gpu || die
# 	rm -f test/ssd_split_table_batched_embeddings_test.py || die
# 	epytest
# }
