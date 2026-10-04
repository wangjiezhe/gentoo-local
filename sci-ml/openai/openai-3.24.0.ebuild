# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="The official Python library for the openai API"
HOMEPAGE="
	https://github.com/openai/openai-python
	https://pypi.org/project/openai/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/httpx2-2.12.0[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/anyio[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	dev-python/jiter[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	dev-python/trove-classifiers[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=(
	pytest-{asyncio,xdist}
	inline-snapshot
	botocore
	trio
)

EPYTEST_IGNORE=(
	tests/api_resources	# need other resources
	tests/test_uv_workflows.py	# no .github folder
	tests/lib/chat/test_completions_streaming.py
	tests/lib/test_fine_tuning_positional_arguments.py
	tests/lib/test_azure_websocket_redirects.py
	tests/test_tls_hostname.py
)

distutils_enable_tests pytest
