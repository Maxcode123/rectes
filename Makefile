.PHONY: clean test lint format type-check install-local-package build-package upload-package start-doc-server deploy-documentation

clean:
	find src -type d -name __pycache__ -prune -exec rm -rf {} +
	rm -rf dist src/rectes.egg-info

test:
	uv run python -m unittest discover -v src/rectes/tests/

lint:
	uv run ruff check src

format:
	uv run ruff format src

type-check:
	uv run ty check src

install-local-package:
	uv pip install -e .

build-package:
	uv build

upload-package:
	uv publish

start-doc-server:
	uv run python -m mkdocs serve

deploy-documentation:
	uv run python -m mkdocs gh-deploy --config-file mkdocs.yml
