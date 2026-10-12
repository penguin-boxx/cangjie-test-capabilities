# Deferred Modal specifications

These 21 specifications depend on capture-dependent modes, Modal constructor/receiver rules, or capability escape analysis. Modal integration is outside the current rewrite scope. LLT discovers `.cj` files; the `.cj.disabled` extension intentionally keeps these files out of both the rewrite gate and broad LLT runs. They are preserved specifications, not current expected failures.

Revisit the syntax and semantics against a stable Modal design before activation. Then rename the selected files to `.cj`, retaining their basenames so `%n.cj` and diagnostic location assertions refer to the executable fixture, and run them with a compiler integrating both features. Do not activate only the parser: escape cases require the semantic diagnostic they assert.

The unchecked-lambda control needs no Modal feature and remains active in `../contracts/unchecked_lambda.cj`. The current non-Modal implementation follows proposal §6.5: it performs no escape checks, including local checks, for either exception or effect capabilities.
