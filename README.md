
[![image](https://img.shields.io/pypi/v/rectes.svg)](https://pypi.python.org/pypi/rectes)
[![image](https://img.shields.io/pypi/l/rectes.svg)](https://opensource.org/license/mit/)
[![image](https://img.shields.io/pypi/pyversions/rectes.svg)](https://pypi.python.org/pypi/rectes)
[![Actions status](https://github.com/Maxcode123/rectes/actions/workflows/test-package.yml/badge.svg?branch=main)](https://github.com/Maxcode123/rectes/actions/workflows/test-package.yml?query=branch%3Amain)

<p align="center">
  <a href="https://maximosnikiforakis.gr/rectes/"><b>Documentation</b></a>
  &nbsp;·&nbsp;
  <a href="https://pypi.org/project/rectes/"><b>PyPI</b></a>
  &nbsp;·&nbsp;
  <a href="https://github.com/Maxcode123/rectes"><b>GitHub</b></a>
</p>

---
# rectes
A simple Python AST evaluator.  
The name is derived from Greek _ρέκτης_ (/'rektis/) meaning doer/one who acts.

rectes is the last stage of a small toolchain:
[lectes](https://github.com/Maxcode123/lectes) scans text into tokens,
[syntactes](https://github.com/Maxcode123/syntactes) parses them into a tree,
and rectes evaluates the tree.

> rectes is in early development, and it has no public API yet.

## Features
* Evaluation of abstract syntax trees, with a callback per node kind
* Scoped environments for binding and looking up names
* No dependencies; only the standard library

## Installation
```
> pip install rectes
```

## License

[MIT](LICENSE)
