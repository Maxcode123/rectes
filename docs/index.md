---
title: What is rectes?
---

<div class="rx-title" markdown="0">
  <p class="rx-kicker">AST evaluator · Python 3.13+</p>
  <p class="rx-logo" aria-hidden="true">RECTES</p>
  <h1 id="what-is-rectes">Build the tree.<br>Get the <span>result.</span></h1>
  <p class="rx-blurb">A small Python AST evaluator with no dependencies.
  Register a callback for each kind of node, and it walks your syntax tree
  and computes its value.</p>
  <div class="rx-buttons">
    <a class="md-button md-button--primary" href="installation/">Press start</a>
    <a class="md-button" href="https://github.com/Maxcode123/rectes">GitHub</a>
  </div>
</div>

`rectes` is an abstract syntax tree evaluator written in Python. It's the last
stage of a small toolchain:

1. [lectes](https://maximosnikiforakis.gr/lectes/) scans text into tokens.
2. [syntactes](https://maximosnikiforakis.gr/syntactes/) parses the tokens and
   builds a tree.
3. rectes evaluates the tree.

- **Callbacks per node kind.** You decide what each kind of node means.
- **Scoped environments.** Names are bound and looked up through nested scopes.
- **No dependencies.** It uses only the standard library.

!!! note
    rectes is in early development, and it has no public API yet.
