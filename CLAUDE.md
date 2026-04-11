# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

collate-sqlfluff is an open-metadata fork of SQLFluff — a dialect-flexible SQL linter and formatter. The package installs as `collate-sqlfluff` but imports as `sqlfluff`.

## Common Commands

### Install for development
```bash
pip install -e .
# Or create a full dev virtualenv with tox (pick a dbt env from tox.ini):
tox -e dbt180 --devenv .venv && source .venv/bin/activate
```

### Run tests
```bash
# Full test suite via tox (pick your Python version from tox.ini envlist)
tox -e py313

# Run specific tests directly
pytest -vv test/core/parser/parser_test.py
pytest -vv -k "test_rule_AL02" test/

# Run a specific test class/method
pytest test/api/test_cli_commands.py::TestLint::test_lint

# Dialect-specific test suites (use markers)
pytest -vv -m parse_suite test/
pytest -vv -m fix_suite test/
pytest -vv -m rules_suite test/

# dbt plugin tests (requires a dbt tox env)
tox -e dbt180 -- plugins/sqlfluff-templater-dbt
```

### Linting and type checking
```bash
tox -e linting       # ruff, black (check), flake8, lint-imports
tox -e mypy          # type checking (strict on sqlfluff.core)
```

### Generate test fixtures (required before committing dialect changes)
```bash
python test/generate_parse_fixture_yml.py
# Or via tox:
tox -e generate-fixture-yml
```

### Full CI-like check
```bash
tox -e generate-fixture-yml,linting,mypy,cov-init,py313,cov-report
```

## Architecture

### Parser Pipeline (4 stages)
1. **Templater** — expands Jinja/dbt/placeholder templates into raw SQL
2. **Lexer** — tokenizes SQL into typed segments
3. **Parser** — builds a parse tree using dialect-specific grammars
4. **Linter** — applies rules to the parse tree and reports violations

### Source layout (`src/sqlfluff/`)
- `api/` — Public Python API (`lint`, `fix`, `parse`, `list_rules`, `list_dialects`)
- `cli/` — Click-based CLI (`sqlfluff lint`, `sqlfluff fix`, `sqlfluff parse`)
- `core/` — Core engine (strictest mypy checking):
  - `parser/` — Lexer, parser, grammar matching
  - `linter/` — Linting orchestration
  - `rules/` — Base rule class and rule infrastructure
  - `templaters/` — Jinja, dbt, placeholder, python templaters
  - `config/` — Configuration loading and resolution
  - `dialects/` — Dialect registry and base/common segment definitions
- `dialects/` — SQL dialect implementations. Each dialect has a `dialect_<name>.py` and usually a `dialect_<name>_keywords.py`. Dialects inherit from ANSI.
- `rules/` — Rule plugins organized by category: `capitalisation/`, `aliasing/`, `layout/`, `references/`, `ambiguous/`, `structure/`, `convention/`, `jinja/`, `tsql/`
- `utils/` — Testing utilities and reflow helpers

### Plugins (`plugins/`)
- `sqlfluff-templater-dbt/` — dbt templater (version-pinned to main package)
- `sqlfluff-plugin-example/` — Example plugin template for custom rules

### Tests (`test/`)
Mirror the source structure. Test files use `*_test.py` naming. Key markers: `parse_suite`, `fix_suite`, `rules_suite`, `dbt`, `integration`.

## Key Development Notes

- **100% coverage required** — enforced in CI (dbt templater excluded from default coverage)
- **lint-imports** enforces strict dependency layering — import cycles between packages will fail CI
- **mypy --strict** applies to `sqlfluff.core` — all other packages get standard mypy
- **Fixture generation** — after modifying dialect grammar, run `python test/generate_parse_fixture_yml.py` to regenerate YAML parse fixtures before committing
- **Plugin install order matters** — the dbt templater pins its version to the main package, so it must be installed after the main package
- **Use the virtual environment when present** — before running Python, pytest, tox, or any project commands, check for a virtual environment (common locations: `venv/`, `.venv/`, `env/`) and use its Python binary (e.g. `venv/bin/python`). Do not use the system Python when a project venv exists.
- **Dialect grammar changes must be backed by sources** — all grammar additions or modifications must reference the official database documentation and match its syntax exactly. If the reported behavior conflicts with the official docs, verify against a live database instance before proceeding. Cite sources (doc links, issue references, verification results) in both code comments and test files.
