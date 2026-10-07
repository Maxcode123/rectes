# rectes

A simple Python AST evaluator. You register a callback for each kind of node,
and it walks a syntax tree and computes its value, binding and looking up names
in scoped environments. It's a library meant for PyPI. Docs will be at
https://maximosnikiforakis.gr/rectes/.

It's the third of a toolchain, next to `../lectes` (a scanner generator) and
`../syntactes` (a parser generator). Follow their conventions unless this file
says otherwise.

The project is a skeleton: the packaging, docs site and CI are in place, and
the Python modules are empty.

## Commands

Use uv for everything. Dev tools (unittest-extensions, ruff, ty, and mkdocs for
the docs) are in the `dev` dependency group, locked in `uv.lock`. Always go
through `uv run python …`.

```sh
make test          # whole unit suite (unittest discover)
make lint          # ruff check
make type-check    # ty
make format        # ruff format
uv run python -m unittest rectes.tests.test_evaluator   # one module
uv run mkdocs build --strict -d <scratch dir>           # check the docs
make start-doc-server                                   # serve the docs locally
```

Before every commit, run `make test`, `make lint` and `make type-check`, and
make sure `uv run ruff format --check src` is clean. CI
(`.github/workflows/test-package.yml`) runs the same four checks on Python
3.13, for pushes to `main` and `tester/*` and for PRs.

## Architecture

All code lives in `src/rectes/`. The planned modules are:

- `node.py`: the tree's nodes. Each has a kind, its children, and an optional
  value.
- `environment.py`: `Environment`, a scope of name bindings with an optional
  parent scope that lookups fall back to.
- `evaluator.py`: `Evaluator`. Callbacks are registered per evaluator and per
  node kind, and `evaluate(node, environment)` dispatches on the node's kind.
- `errors.py`: `EvaluationError` and its subclasses (e.g. no callback for a
  node kind, an undefined name).
- `tests/`: one `test_<module>.py` per module, plus `test_package.py` for the
  public exports.

The docs site (`mkdocs.yml`, `docs/`) is MkDocs Material with mkdocstrings,
laid out like the lectes and syntactes docs. It shares their arcade look, with
its own amber phosphor palette: `docs/stylesheets/arcade.css` maps Material's
dark (`slate`) palette onto the `--rx-*` colours. The fonts in
`docs/assets/fonts/` are copied from syntactes.

## Rules

- **No runtime dependencies** (`dependencies = []`). Use the stdlib only.
  Adding a runtime dependency needs explicit approval. Dev-only tools go in the
  `dev` dependency group (`uv add --dev …`).
- **Python 3.13+** (`requires-python = ">=3.13"`). Modern syntax is fine, and
  ruff enforces it. Use PEP 695 generics, `type` aliases, and `typing.Self`.
- **The public API** is everything exported from `rectes/__init__.py`, plus the
  behaviour the README shows. Once released, point out any breaking change and
  get agreement before making it.
- New public names go in `rectes/__init__.py` (as `from .x import Y as Y`), with
  an identity check in `tests/test_package.py`. Modules prefixed with `_` are
  private.

## Workflow

- **Test first, always.** For every behaviour change or bug fix:
  1. Write the tests.
  2. Run them and watch them fail.
  3. Implement until they pass.

  Tests and implementation go in the same commit.
- **Tests** use `unittest` with `unittest-extensions`. A test class defines
  `subject(...)`, test methods are decorated with `@args(...)`, and they call
  `self.result()`, `self.assertResult(...)` or
  `self.assertResultRaises(...)`. Shared setup and assert helpers go on a base
  `TestCase`.
- **Git:**
  - Always work on a branch, never directly on `main`.
  - Make small atomic commits, each one passing the checks.
  - Write commit subjects in the present tense, third person, e.g. "Adds …",
    "Fixes …", "Documents …", "Bumps version to X.Y.Z". Add a body explaining
    *why* when it isn't obvious.
  - Don't merge into `main`, push, tag, publish or deploy docs unless asked.
    When asked to merge, use `git merge --no-ff <branch>` (message:
    `Merge branch '<branch>'`).
- **Docs go with every user-facing change, on the same branch:**
  - Update the relevant `docs/*.md` page and, if needed, `README.md`. Run every
    code sample you add, and paste its real output.
  - Add a bullet under `## X.Y.Z - Unreleased` in `CHANGELOG.md`, in the
    `Breaking changes` / `Added` / `Changed` / `Fixed` sections.
  - New pages go in the `mkdocs.yml` nav. API pages are `::: module` stubs
    rendered by mkdocstrings, which leaves out objects without a docstring,
    so give new public classes and methods one.
- **Code style:**
  - Formatting is ruff's (line length 88).
  - Type hints everywhere, and ty must pass. Prefer real narrowing over `cast`.
  - Prefix private helpers and modules with `_`.
  - Docstrings are triple-quoted, with the text starting on the next line.
    Public docstrings explain the behaviour, with `Raises:` sections.
  - Error messages are lowercase and show user values with `repr`.
- `.envrc` holds secrets and is git-ignored. Never print it or commit it.

## Release (only when asked)

1. On the branch, set `version` in `pyproject.toml`, run `uv lock`, change
   `## X.Y.Z - Unreleased` in `CHANGELOG.md` to today's date, and commit as
   "Bumps version to X.Y.Z".
2. Merge into `main` with `--no-ff`, run `make test`, then
   `git push origin main`.
3. Run `git tag X.Y.Z`, then `git push origin X.Y.Z`.
4. Run `make clean build-package` (`uv build`). Check that `dist/` holds only
   X.Y.Z, and that the wheel has what you expect (e.g. `unzip -l dist/*.whl`).
   It should hold no `tests`.
5. Run `make upload-package` (`uv publish`). It reads `UV_PUBLISH_TOKEN` from
   `.envrc` (via direnv). Never print it.
6. Run `make deploy-documentation` (`mkdocs gh-deploy`). GitHub Pages takes a
   few minutes to rebuild. Check progress with
   `gh api repos/Maxcode123/rectes/pages/builds/latest`.
7. Verify from outside the repo:
   `uvx --refresh --from rectes==X.Y.Z python -c "import rectes"`, and check
   the changed docs pages on the live site.

Pitfalls:

- Never build unreleased code into `dist/` under an already-released version
  number. To try a local build, use `uv build -o <scratch dir>`.
