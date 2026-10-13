# Section 6 compatibility and migration acceptance

These fixtures extend the [architecture](../../../../../../../notes/architecture.md) and [sections 3/5 coverage audit](../COVERAGE.md) to proposal §6. They are executable acceptance requirements; none are XFAIL or excluded. The declaration-local rewrite's previous green baseline predates this extension. Modal integration and the optional closed-build verifier remain deferred.

## Coverage

| Proposal rule | Focused tests |
|---|---|
| §6.1 independent Off/Warn/Error axes | All nine `axes_*` combinations; unchecked effects with handlers enabled; both warning groups; separate-argument CLI forms; checked effects require handler feature. |
| §6.1 selective severity | `mixed_captures_*` requires both severities at one constructor; `effect_type_*`, `effect_override_*`, and `effect_cast_warn` cover non-demand violations; `ordinary_error_warn` and `wellformed_*` must remain errors. Existing exception warning/error twins remain regression gates. |
| §6.2 enabled-axis projection throughout metadata | `metadata_*` records nested functions inside invariant arrays, direct callable types, and mixed capturing constructor requirements for Off, exceptions-only, effects-only, both Error, and both Warn producers; unchecked consumer projection is separate. `generic_effect_subclass_bound_neg` retains generic command-subclass bounds through producer elaboration and metadata. |
| §6.2 package visibility and trust | `internal_subpackage_neg` consumes an inferred internal parent contract; `warn_metadata_neg` uses a warning-producing dependency with warnings suppressed but its clauses preserved. `reject_recorded_*` rejects assumptions on Warn metadata. Existing `assume_on_checked_neg` retains the Error control. |
| §6.3.1 unchecked invocation boundaries | `unchecked_dispatch_neg` still requires the checked static interface contract even with an unchecked implementation; `metadata_off_consumer` lets unchecked code invoke recorded functions. Existing `serialization/xpkg_off_consumer` covers the exception-only boundary. |
| §6.3.2 callback types versus formation demands | `reference_formation`, four `delayed_*_neg` cases, nested/tuple results, `assumed_identity_neg`, and invariant ordinary generic inference. A call or getter pays at invocation; its returned callback retains a separate later obligation. |
| §6.3.2 input/output polarity | Three `write_*_neg` cases reject widened storage/setter/ordinary inputs; `setter_demand_neg` requires the setter call's capability; `invariant_extraction` leaves functions inside nominal type arguments clause-free. |
| §6.3.2 scope and trust | `package_union_neg` merges aliases across files and unannotated member imports; `assumption_subpackage` keeps dependency subpackages separate; cross-axis eligibility, dual annotations, and invalid effect-assumption forms are explicit tests. Existing assumption fixtures retain bare `AssumeThrows`, empty lists, placement, and aliases. |
| §6.3.2 metadata locality | `assumption_export_neg` exports the consumer's derived callback list without changing the dependency's original contract. This case also requires formation without a demand while building the bridge library. |
| §6.3.3 callback boundary | `write_argument_neg` rejects a throwing callback passed to an unchecked callable even under an assumed supply; `callback_discharge` accepts a handled wrapper. Mode-based rejection is deferred with Modal. |
| §6.3.4 guarantee | No new runtime checks or mandatory build rejection are specified. ABI/reflection regressions remain applicable; the optional verifier, trust provenance records, and signature-coherence verdict need their own future tool tests. These source tests do not prove a closed-build guarantee. |
| §6.4 migration and incremental checking | `incremental_enable` changes only the consumer checking option; `incremental_dependency_level` changes only the producer level from Off to Warn. Existing `assume/incr_assume` and alias/signature incremental tests remain gates. |
| §6.5 non-Modal mode | `nonmodal_escape` and `nonmodal_effect_escape` allow captured callbacks to leave handlers without invoking them afterward. Existing primary/default constructors, receivers/extensions, nominal casts, and deferred Modal specifications are retained. |

Focused compiler units cover independent levels and option prerequisites, producer policy round trips and defaults for old artifacts, capturing status surviving an empty filtered list, command-subclass generic bounds, immutable import views, package isolation, and declaration-context restoration during on-use completion. Source drivers cover warning suppression, explicit and implicit invocation requirements, and consumer-visible types. The optional verifier’s evidence format and future Modal metadata require separate acceptance tests when those features exist.

## Running and current baseline

Run `./cj.py test llt --filter compiler/CheckedExceptions/rewrite/compat`, then the changed existing fixtures and the full checked-exceptions/effect regression suites after implementation. The tests use the existing LLT configuration and stdx effect library. Effect checking now needs `--enable-checked-effects error` in addition to `%enableEH`; 30 existing effect drivers were migrated to state that explicitly. The existing `assume/assume_covariant_neg.cj` now asserts invocation locations instead of the prototype's incorrect formation locations. Prototype `--enable-checked-exceptions=error` syntax remains in semantic fixtures to isolate the CLI prerequisite; `cli_exception_level` separately requires the proposal's `--enable-checked-exceptions error` spelling.

Baseline on 2026-10-12: compiler checkout `43abc5df`, installed `cjc` SHA-256 `e6f5650fec7724ede23591361cf82a6ed7aeb4bdccd8bd14a3e3256de5ea4579`. The host LLT harness uses Python's fork start method and the installed stdx. No compiler implementation was changed for this extension.

| Selection | Pass | Fail | Unresolved |
|---|---:|---:|---:|
| 63 new compatibility drivers | 15 | 48 | 0 |
| 31 revised existing drivers | 0 | 31 | 0 |
| Total changed acceptance drivers | 15 | 79 | 0 |

Of the 48 new failures, 33 stop at unsupported checking options, so their semantic bodies are not yet validated by the acceptance run. Fifteen expose existing semantic/cache behavior: effect checking remains on when its axis should be off (three cases), assumption types/formation/propagation are wrong (ten cases), and option-only consumer or dependency changes miss incremental rechecking (two cases). The revised drivers expose 30 missing checked-effect option prerequisites and the old assumption-formation behavior. The combined 94-driver run was followed by a 14-driver rerun after strengthening severity and annotation-diagnostic assertions; their outcomes were unchanged. Missing options, parser failures, or unrelated type errors do not satisfy a negative test. Some fixtures require a support package to compile first; failure in that prerequisite is reported as failure, not counted as the intended consumer rejection.

Additional syntax controls compiled the new mixed metadata library and the non-Modal effect escape example under the prototype flags. Effect type/override/cast controls and mixed constructor demands reached their intended semantic checks under those flags. These controls validate fixture syntax only; they do not count as passes for the specified independent-axis semantics. No new full Sema, std/stdx rebuild, or LSP/cjd gate was run for this architecture/test-only change.

## Case inventory

Each negative checks a semantic diagnostic; marked rejection sites additionally have source-location assertions. Positive controls execute their safe paths where useful. Bodies representing an unchecked boundary or an escaped capability need not be invoked to test their static acceptance.

| Driver | Expected | Baseline | Requirement |
|---|---|---|---|
| [axes_off_off](axes_off_off.cj) | accept/run | FAIL: semantics/cache | §6.1: exception off, effects off; handler enablement alone does not enable checking. |
| [axes_off_warn](axes_off_warn.cj) | accept/run | FAIL: option prerequisite | §6.1: exception off, effects warn; handler enablement alone does not enable checking. |
| [axes_off_error](axes_off_error.cj) | reject | FAIL: option prerequisite | §6.1: exception off, effects error; handler enablement alone does not enable checking. |
| [axes_warn_off](axes_warn_off.cj) | accept/run | FAIL: semantics/cache | §6.1: exception warn, effects off; handler enablement alone does not enable checking. |
| [axes_warn_warn](axes_warn_warn.cj) | accept/run | FAIL: option prerequisite | §6.1: exception warn, effects warn; handler enablement alone does not enable checking. |
| [axes_warn_error](axes_warn_error.cj) | reject | FAIL: option prerequisite | §6.1: exception warn, effects error; handler enablement alone does not enable checking. |
| [axes_error_off](axes_error_off.cj) | reject | FAIL: semantics/cache | §6.1: exception error, effects off; handler enablement alone does not enable checking. |
| [axes_error_warn](axes_error_warn.cj) | reject | FAIL: option prerequisite | §6.1: exception error, effects warn; handler enablement alone does not enable checking. |
| [axes_error_error](axes_error_error.cj) | reject | FAIL: option prerequisite | §6.1: exception error, effects error; handler enablement alone does not enable checking. |
| [suppress_checked_exceptions](suppress_checked_exceptions.cj) | accept/run | FAIL: option prerequisite | §6.1: warning groups suppress only their own kind. |
| [suppress_checked_effects](suppress_checked_effects.cj) | accept/run | FAIL: option prerequisite | §6.1: warning groups suppress only their own kind. |
| [cli_exception_level](cli_exception_level.cj) | accept/run | FAIL: option prerequisite | §6.1: specified separate-argument option spelling. |
| [cli_effect_level](cli_effect_level.cj) | accept/run | FAIL: option prerequisite | §6.1: specified effect option spelling. |
| [wellformed_off](wellformed_off.cj) | reject | PASS | §6.1: invalid clauses remain errors with checking off. |
| [wellformed_warn](wellformed_warn.cj) | reject | PASS | §6.1: invalid clauses remain errors with checking warn. |
| [ordinary_error_warn](ordinary_error_warn.cj) | reject | PASS | §6.1: ordinary type failures are never downgraded. |
| [effect_type_warn](effect_type_warn.cj) | accept/run | FAIL: option prerequisite | §6.1: effect-only functional incompatibility follows the effect level. |
| [effect_type_error](effect_type_error.cj) | reject | FAIL: option prerequisite | §6.1: effect-only functional incompatibility follows the effect level. |
| [effect_cast_warn](effect_cast_warn.cj) | accept/run | FAIL: option prerequisite | §6.1: functional casts follow effect warn with exceptions off. |
| [reference_formation](reference_formation.cj) | accept/run | FAIL: semantics/cache | §6.3.2: fields and bound methods acquire types without a formation demand. |
| [delayed_field_neg](delayed_field_neg.cj) | reject | FAIL: semantics/cache | §6.3.2: field obtained inside a handler still requires AE when invoked later. |
| [delayed_bound_neg](delayed_bound_neg.cj) | reject | FAIL: semantics/cache | §6.3.2: bound obtained inside a handler still requires AE when invoked later. |
| [delayed_result_neg](delayed_result_neg.cj) | reject | FAIL: semantics/cache | §6.3.2: result obtained inside a handler still requires AE when invoked later. |
| [delayed_property_neg](delayed_property_neg.cj) | reject | FAIL: semantics/cache | §6.3.2: property obtained inside a handler still requires AE when invoked later. |
| [nested_result_neg](nested_result_neg.cj) | reject | FAIL: semantics/cache | §6.3.2: positive functional result positions are transformed recursively. |
| [tuple_result_neg](tuple_result_neg.cj) | reject | FAIL: semantics/cache | §6.3.2: tuples preserve covariant functional results. |
| [reference_invariant_neg](reference_invariant_neg.cj) | reject | FAIL: semantics/cache | §6.3.2: an assumed reference reaches invariant ordinary generic inference. |
| [write_field_neg](write_field_neg.cj) | reject | PASS | §6.3.2–3: assumptions do not widen field input types. |
| [write_property_neg](write_property_neg.cj) | reject | PASS | §6.3.2–3: assumptions do not widen property input types. |
| [write_argument_neg](write_argument_neg.cj) | reject | PASS | §6.3.2–3: assumptions do not widen argument input types. |
| [setter_demand_neg](setter_demand_neg.cj) | reject | PASS | §6.3.2: a setter call demands AE even for a clause-free argument. |
| [invariant_extraction](invariant_extraction.cj) | accept/run | PASS | §6.3.2: nominal type arguments are not rewritten by assumptions. |
| [callback_discharge](callback_discharge.cj) | accept/run | PASS | §6.3.3: handle a checked callback before passing it to unchecked code. |
| [assumption_export_neg](assumption_export_neg.cj) | reject | FAIL: semantics/cache | §6.2–3: the consumer exports derived callback clauses; the dependency stays unchanged. |
| [package_union_neg](package_union_neg.cj) | reject | PASS | §6.3.2: aliases and repeated imports merge across files; member uses see the union. |
| [metadata_off](metadata_off.cj) | accept/run | FAIL: option prerequisite | §6.2: producer off filters nested clauses and mixed captures independently. |
| [metadata_exceptions](metadata_exceptions.cj) | accept/run | FAIL: option prerequisite | §6.2: producer exceptions filters nested clauses and mixed captures independently. |
| [metadata_effects](metadata_effects.cj) | accept/run | FAIL: option prerequisite | §6.2: producer effects filters nested clauses and mixed captures independently. |
| [metadata_both](metadata_both.cj) | accept/run | FAIL: option prerequisite | §6.2: producer both filters nested clauses and mixed captures independently. |
| [metadata_warn](metadata_warn.cj) | accept/run | FAIL: option prerequisite | §6.2: producer warn filters nested clauses and mixed captures independently. |
| [metadata_off_consumer](metadata_off_consumer.cj) | accept/run | FAIL: option prerequisite | §6.3.1: unchecked consumer projects both recorded axes away. |
| [warn_metadata_neg](warn_metadata_neg.cj) | reject | PASS | §6.1–2: warning suppression preserves trusted signatures and enabled producer identity. |
| [cross_axis_assume_throws](cross_axis_assume_throws.cj) | accept/run | FAIL: option prerequisite | §6.3.2: recorded effects do not prohibit exception assumptions. |
| [cross_axis_assume_performs](cross_axis_assume_performs.cj) | accept/run | FAIL: option prerequisite | §6.3.2: recorded exceptions do not prohibit effect assumptions. |
| [reject_recorded_throws](reject_recorded_throws.cj) | reject | FAIL: option prerequisite | §6.3.2: assumptions reject Warn metadata on the same axis. |
| [reject_recorded_performs](reject_recorded_performs.cj) | reject | FAIL: option prerequisite | §6.3.2: assumptions reject Warn metadata on the same axis. |
| [dual_assumptions_neg](dual_assumptions_neg.cj) | reject | FAIL: option prerequisite | §6.3.2: both assumptions compose and function-value invocation retains both. |
| [assume_performs_bare_neg](assume_performs_bare_neg.cj) | reject | FAIL: option prerequisite | §6.3.2: effect assumptions reject bare form. |
| [assume_performs_empty_neg](assume_performs_empty_neg.cj) | reject | FAIL: option prerequisite | §6.3.2: effect assumptions reject empty form. |
| [assume_performs_member_neg](assume_performs_member_neg.cj) | reject | FAIL: option prerequisite | §6.3.2: effect assumptions reject member form. |
| [nonmodal_escape](nonmodal_escape.cj) | accept/run | PASS | §6.5: no intra-function or returned-value escape rejection without Modal. |
| [nonmodal_effect_escape](nonmodal_effect_escape.cj) | accept/run | FAIL: option prerequisite | §6.5: captured effects have the same unchecked escape discipline. |
| [incremental_enable](incremental_enable.cj) | reject | FAIL: semantics/cache | §6.1–2: option changes invalidate cached unchecked results. |
| [mixed_captures_warn_error](mixed_captures_warn_error.cj) | reject | FAIL: option prerequisite | §6.1: one constructor has independent exception/effect severities. |
| [mixed_captures_error_warn](mixed_captures_error_warn.cj) | reject | FAIL: option prerequisite | §6.1: one constructor has independent exception/effect severities. |
| [effect_override_warn](effect_override_warn.cj) | accept/run | FAIL: option prerequisite | §6.1: overriding capability components follows effect severity. |
| [effect_override_error](effect_override_error.cj) | reject | FAIL: option prerequisite | §6.1: overriding capability components follows effect severity. |
| [effect_requires_feature](effect_requires_feature.cj) | reject | FAIL: option prerequisite | §6.1: checked effects require the handler feature. |
| [unchecked_dispatch_neg](unchecked_dispatch_neg.cj) | reject | PASS | §6.3.1: unchecked implementation does not erase the selected interface contract. |
| [internal_subpackage_neg](internal_subpackage_neg.cj) | reject | PASS | §6.2: inferred internal lists are serialized for subpackage consumers. |
| [assumption_subpackage](assumption_subpackage.cj) | accept/run | PASS | §6.3.2: assuming a dependency package does not assume its subpackage. |
| [assumed_identity_neg](assumed_identity_neg.cj) | reject | FAIL: semantics/cache | §6.3.2: generic identity and inferred factory retain the assumed callback type. |
| [incremental_dependency_level](incremental_dependency_level.cj) | reject | FAIL: semantics/cache | §6.2: changed dependency trust/clauses invalidate unchanged consumer source. |

## Implementation regressions and validation — 2026-10-13

The implementation adds seven active drivers to the original 63: [assumption_ast_roundtrip](assumption_ast_roundtrip.cj) preserves both annotation lists through `std.ast`; [generic_effect_contract_neg](generic_effect_contract_neg.cj) retains bounded command clauses after generic elaboration; [mixed_captures_warn_warn](mixed_captures_warn_warn.cj) and [capture_coverage_warn](capture_coverage_warn.cj) preserve both warning kinds; [assume_performs_misplaced_neg](assume_performs_misplaced_neg.cj) validates placement with checking Off; [mixed_cast_warn_warn](mixed_cast_warn_warn.cj) keeps identical cast diagnostics visible in both warning groups; and [generic_effect_subclass_bound_neg](generic_effect_subclass_bound_neg.cj) retains subclass-bounded effect parameters through an effects-only producer and its metadata consumer.

Acceptance against the final compiler and rebuilt SDK passes all 70 compatibility drivers as part of the complete 365-driver checked-exception/effect gate. All 175 active rewrite drivers pass; the 21 Modal specifications remain deferred. All 49 compiler unit suites pass, including the new independent-level, explicit-option, pure-projection, package-isolation, producer-policy, historical-handler-bit, empty-capture-identity, subclass-bound, and on-use declaration-context checks. The baseline table and case inventory above retain the pre-implementation results for comparison.

Validation uses Docker image `cangjie-dev`, `cjc 1.0.0` targeting `x86_64-unknown-linux-gnu`, and compiler SHA-256 `1e80d5bdfd3757921d0d444a0daca73a3fae79c6741a102c014646d1b86309c4`. All 46 std and 38 stdx module archives were invalidated and rebuilt with both checking axes at Warn, including AST and macro libraries. Current logs are `logs/section6-feature-final-v3.log`, `logs/section6-units-final-v3.log`, and `logs/section6-sdk-final-v3.log` in the workspace. The full configured Sema, incremental, macro, and module gate passes all 6,315 drivers against that same build, with existing exclusions unchanged; its final log is `logs/section6-broad-final-v4.log`. The workspace gap ledger records the complete gate and deferred scope.
