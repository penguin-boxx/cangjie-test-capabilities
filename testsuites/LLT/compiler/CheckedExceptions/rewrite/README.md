# Contract-scheduling rewrite acceptance tests

These are executable LLT acceptance tests for sections 3 and 5 under the non-Modal scope of §6.5 of the checked-exceptions proposal and the dependency-ordered architecture in the workspace's `notes/architecture.md`. The active cases are not `XFAIL`, excluded, or weakened to preserve a green prototype baseline. A successful rewrite must pass positive execution cases and reject negative cases for the specified semantic reason. Section 4 and Modal-dependent rules are deferred; 21 specifications are retained under [deferred-modal](deferred-modal/README.md) with `.cj.disabled` extensions and are not discovered by LLT.

The 2026-10-09 implementation policy rejects recursive inference groups, including self-cycles, empty cycles, cycles through function values, and ellipsis clauses. Fully written contracts permit recursive execution; writing enough complete contracts can break a dependency cycle. This policy precedes the author's planned change to proposal §5.3.4. An explicitly written clause with a recursively inferred result type is still incomplete; the existing return-type cycle diagnostic is acceptable for that ordinary inference failure.

## Running

From the workspace root:

```sh
./cj.py test llt --filter compiler/CheckedExceptions/rewrite
./cj.py test llt --filter compiler/CheckedExceptions/inference/infer_recursion.cj compiler/CheckedExceptions/inference/infer_poly_recursion_neg.cj
./cj.py test llt --filter compiler/CheckedExceptions compiler/Sema/effect
```

`contracts` requires checked exceptions; `cycles` additionally pins the new scheduler policy. The `deferred-modal` specifications require Modal integration and are outside this gate. `captures` with ordinary constructors and receivers remains in scope; capture-dependent modes and all escape checks are deferred. The effect cases use the standard `%enableEH` configuration and the existing stdx effect library. Missing syntax support is a failing prerequisite, not a passing negative test. The standard effect flag is used here to test §5.4 semantics independently of the separate checking-axis work in section 6.

Positive execution cases normally use checked exceptions at error level. `audit/implicit_protocol_inference.cj` uses warning mode with specific caller-demand assertions because current std protocol contracts are empty; the explicit warning/error twins separately pin migration severity. Negative tests require compiler exit 1, a semantic diagnostic, and (where marked `// ERROR`) a source location at each intended rejection site. Parser-error diagnostics and internal compiler errors cannot satisfy a negative test. The cycle diagnostic stem `recursive capability inference` is an acceptance requirement; remaining wording is flexible. Diagnostic counts are deliberately not pinned because the compiler can visit desugared sites more than once.

## Initial rewrite coverage (43 cases)

| Group | File | Design | Expected | What it establishes |
|---|---|---|---|---|
| contracts | [order_callers_first.cj](contracts/order_callers_first.cj) | §3.4.3, §3.5, §5.3.2–3 | run | Equivalent source-order permutations must infer the same joined and returned contracts. |
| contracts | [order_callees_first.cj](contracts/order_callees_first.cj) | §3.4.3, §3.5, §5.3.2–3 | run | Equivalent source-order permutations must infer the same joined and returned contracts. |
| contracts | [written_equivalent.cj](contracts/written_equivalent.cj) | §3.4.3, §5.3.3 | run | Written twin of both order tests: inferred and written contracts have identical observable behavior. |
| contracts | [generic_values.cj](contracts/generic_values.cj) | §3.4, §3.6, §5.3.3 | run | Generic substitution must preserve completed function types, including invariant containers and joins. |
| contracts | [patterns_and_results.cj](contracts/patterns_and_results.cj) | §3.4.3, §5.3.2–3 | run | Requirements propagate through match bindings, tuple/array projections, inferred results and callers. |
| contracts | [canonical_and_meet.cj](contracts/canonical_and_meet.cj) | §3.2, §3.4, §5.2 | run | Normalize inferred lists before invariant identity; preserve contravariant meets in returned functions. |
| contracts | [members_defaults_fields.cj](contracts/members_defaults_fields.cj) | §3.2–3, §5.3.2 | run | Complete member, accessor, default-expression and field-initializer dependencies before their consumers. |
| contracts | [authoritative_and_dots.cj](contracts/authoritative_and_dots.cj) | §3.3, §5.3.1–2, §5.3.5 | run | Ellipsis adds residual requirements; handling and explicit callback parameters remove them. |
| contracts | [unchecked_and_assumption.cj](contracts/unchecked_and_assumption.cj) | §5.1, §5.3 | run | Unchecked substitution erases requirements; static Exception still requires one; the escape hatch removes one. |
| contracts | [missing_join_neg.cj](contracts/missing_join_neg.cj) | §3.3, §3.4.3, §5.3.3 | reject | A caller of an inferred joined value must require both branch capabilities. |
| contracts | [formed_value_neg.cj](contracts/formed_value_neg.cj) | §3.4–6, §5.3.3 | reject | A completed inferred requirement cannot be erased by conversion. |
| contracts | [generic_invariant_neg.cj](contracts/generic_invariant_neg.cj) | §3.4–6, §5.3.3 | reject | A completed inferred requirement cannot be erased by conversion. |
| contracts | [result_neg.cj](contracts/result_neg.cj) | §3.4–6, §5.3.3 | reject | A completed inferred requirement cannot be erased by conversion. |
| contracts | [authoritative_body_neg.cj](contracts/authoritative_body_neg.cj) | §5.3.1, §5.3.5 | reject | Published authoritative contracts must not skip validation of unused bodies. |
| contracts | [clause_only_generic_neg.cj](contracts/clause_only_generic_neg.cj) | §3.6 | reject | A callback clause cannot infer exception type variables. |
| contracts | [overload_handlers_neg.cj](contracts/overload_handlers_neg.cj) | §3.7 | reject | A suitable handler for another overload must not change the ordinary selected overload. |
| contracts | [inferred_override_neg.cj](contracts/inferred_override_neg.cj) | §3.8, §5.3.1 | reject | Complete an inferred override before validating its interface contract. |
| contracts | [long_dependency_chain_neg.cj](contracts/long_dependency_chain_neg.cj) | §5.3.3 | reject | Forty inferred-result edges must not hit the old 32-round completion cutoff. |
| cycles | [self_neg.cj](cycles/self_neg.cj) | §5.3.4 rewrite policy | reject | An active inferred contract cannot satisfy its own dependency; do not infer an SCC fixpoint. |
| cycles | [empty_self_neg.cj](cycles/empty_self_neg.cj) | §5.3.4 rewrite policy | reject | An active inferred contract cannot satisfy its own dependency; do not infer an SCC fixpoint. |
| cycles | [mutual_neg.cj](cycles/mutual_neg.cj) | §5.3.4 rewrite policy | reject | An active inferred contract cannot satisfy its own dependency; do not infer an SCC fixpoint. |
| cycles | [value_edge_neg.cj](cycles/value_edge_neg.cj) | §5.3.4 rewrite policy | reject | An active inferred contract cannot satisfy its own dependency; do not infer an SCC fixpoint. |
| cycles | [handled_cycle_neg.cj](cycles/handled_cycle_neg.cj) | §5.3.4 rewrite policy | reject | An active inferred contract cannot satisfy its own dependency; do not infer an SCC fixpoint. |
| cycles | [ellipsis_cycle_neg.cj](cycles/ellipsis_cycle_neg.cj) | §5.3.4 rewrite policy | reject | An active inferred contract cannot satisfy its own dependency; do not infer an SCC fixpoint. |
| cycles | [local_cycle_neg.cj](cycles/local_cycle_neg.cj) | §5.3.4 rewrite policy | reject | An active inferred contract cannot satisfy its own dependency; do not infer an SCC fixpoint. |
| cycles | [partial_contract_neg.cj](cycles/partial_contract_neg.cj) | §5.3.4 rewrite policy | reject | An active inferred contract cannot satisfy its own dependency; do not infer an SCC fixpoint. |
| cycles | [annotated_and_cut.cj](cycles/annotated_and_cut.cj) | §5.3.4 rewrite policy | run | Complete annotations permit recursion and cut mixed inferred/written dependency cycles. |
| effects | [mixed_requirements.cj](effects/mixed_requirements.cj) | §3.4, §5.4 | run | Exception inference preserves written effect requirements through returned function values. |
| effects | [no_effect_inference_neg.cj](effects/no_effect_inference_neg.cj) | §5.4.1 | reject | A private declaration cannot infer its performs clause. |
| effects | [resume_sibling_catch.cj](effects/resume_sibling_catch.cj) | §5.4.5 | run | Resume throwing uses the catches of the suspended protected body. |
| effects | [handler_body_scope_neg.cj](effects/handler_body_scope_neg.cj) | §3.3, §5.4 | reject | A handle body cannot discharge another perform against its own handler. |
| contracts | [property_header.cj](contracts/property_header.cj) | §3.2, §3.3.2 | run | Property-level clauses supply accessor bodies and impose requirements on property reads. |
| contracts | [property_header_neg.cj](contracts/property_header_neg.cj) | §3.2, §3.3.2 | reject | An explicit empty property-level clause must constrain the getter body. |
| contracts | [catch_finally_scope_neg.cj](contracts/catch_finally_scope_neg.cj) | §3.3.2, §5.3.2 | reject | A try supplies neither its catch nor its user-written finally body. |
| contracts | [static_initializer_neg.cj](contracts/static_initializer_neg.cj) | §3.3.2, §5.3.2 | reject | Static initialization has no caller from which to infer a capability. |
| contracts | [unchecked_lambda.cj](contracts/unchecked_lambda.cj) | §3.5, §5.1.2 | run | An unchecked throw does not introduce a capability requirement for a literal. |
| effects | [expected_literal.cj](effects/expected_literal.cj) | §3.5, §5.4 | run | An expected performs list supplies the literal itself; the higher-order function handles the demand. |
| contracts | [generic_values_written.cj](contracts/generic_values_written.cj) | §3–5 equivalence control | run | Authoritative-clause twin of generic_values; both variants must compile and run identically. |
| contracts | [patterns_and_results_written.cj](contracts/patterns_and_results_written.cj) | §3–5 equivalence control | run | Authoritative-clause twin of patterns_and_results; both variants must compile and run identically. |
| contracts | [members_defaults_fields_written.cj](contracts/members_defaults_fields_written.cj) | §3–5 equivalence control | run | Authoritative-clause twin of members_defaults_fields; both variants must compile and run identically. |
| contracts | [nominal_projection.cj](contracts/nominal_projection.cj) | §3.4–6, §5.3.3 | run | An inferred function type survives generic construction and projection to an interface. |
| contracts | [capability_not_value_neg.cj](contracts/capability_not_value_neg.cj) | §3.1, §3.3.4 | reject | The intrinsic capability cannot be named as an ordinary parameter type. |
| contracts | [dependency_scope_isolation_neg.cj](contracts/dependency_scope_isolation_neg.cj) | §3.3, §5.3.2 | reject | Completing a callee from inside a handler must not lend that handler to the callee body. |

`order_callers_first`, `order_callees_first`, and `written_equivalent` contain the same behavior with reordered or authoritative contracts. Each joined call catches both statically required types and asserts which handler actually ran. `generic_values` covers both preservation of a full functional type in `T` and reconciliation of ground capability lists; it does not request inference of exception variables from a clause. `long_dependency_chain_neg` rejects a call through forty inferred result-type dependencies, catching the old bounded completion walk even when ordinary positive calls under a handler would conceal an empty inferred list.

## Coverage audit — 2026-10-12

The [section-by-section audit and new-case inventory](COVERAGE.md) adds 48 executable cases under `audit/` and records the remaining internal resolver and compiler-entry-point obligations. At the pre-migration baseline, the rewrite suite had 91 cases and the binary passed 60 and failed 31; the full `CheckedExceptions` selection passed 218 and failed 35 across 253 executable drivers. These totals combine the broad run and disjoint follow-ups documented in the audit.

The audit also corrects obsolete legacy expectations for primary/default constructors and nominal casts to capturing types under §6.5. Warning-mode protocol coverage is explicitly identified; it is not a substitute for error-level acceptance against compatible standard-library contracts. Six files under `audit/` are build dependencies without test directives.

## Deferred coverage

These cases describe future Modal semantics, not requirements of the non-Modal rewrite. Even the syntax-free capture-mode negatives are deferred: §6.5 omits those restrictions. The unchecked-lambda control remains active because it checks clause behavior without Modal support.

| Group | File | Design | Expected after integration | What it establishes |
|---|---|---|---|---|
| modal | [capture_modes.cj](deferred-modal/modal/capture_modes.cj.disabled) | §3.5, §4.4.5, §5.3.3 | run | Both inferred and written demands synthesize local? captures; expected clauses avoid capture. |
| modal | [outer_origin_and_dynamic_handler.cj](deferred-modal/modal/outer_origin_and_dynamic_handler.cj.disabled) | §3.1, §3.3.3, §4.4.4 | run | Using an outer capture inside an inner try neither retags it nor changes dynamic handler dispatch. |
| modal | [local_aggregate.cj](deferred-modal/modal/local_aggregate.cj.disabled) | §4.4.1–2 | run | Aliases, call results and tuple projections remain usable inside their supplying try. |
| modal | [unrestricted_capture_neg.cj](deferred-modal/modal/unrestricted_capture_neg.cj.disabled) | §3.5, §4.4.5, §5.3.3 | reject | Capability capture must affect ordinary mode compatibility before the value is consumed. |
| modal | [ordinary_transitive_capture_neg.cj](deferred-modal/modal/ordinary_transitive_capture_neg.cj.disabled) | §3.5, §4.4.5, §5.3.3 | reject | Capability capture must affect ordinary mode compatibility before the value is consumed. |
| modal | [escaping_parameter_neg.cj](deferred-modal/modal/escaping_parameter_neg.cj.disabled) | §3.5, §4.4.5, §5.3.3 | reject | Capability capture must affect ordinary mode compatibility before the value is consumed. |
| modal | [outward_assignment_neg.cj](deferred-modal/modal/outward_assignment_neg.cj.disabled) | §3.3.3, §4.4 | reject | A value must not carry a protected-body capability across that body boundary. |
| modal | [call_tuple_escape_neg.cj](deferred-modal/modal/call_tuple_escape_neg.cj.disabled) | §3.3.3, §4.4 | reject | A value must not carry a protected-body capability across that body boundary. |
| modal | [innermost_supply_neg.cj](deferred-modal/modal/innermost_supply_neg.cj.disabled) | §3.3.3, §4.4 | reject | A value must not carry a protected-body capability across that body boundary. |
| modal | [inner_origin_neg.cj](deferred-modal/modal/inner_origin_neg.cj.disabled) | §3.3.3, §4.4 | reject | A value must not carry a protected-body capability across that body boundary. |
| modal | [aggregate_try_result_neg.cj](deferred-modal/modal/aggregate_try_result_neg.cj.disabled) | §3.3.3, §4.4 | reject | A value must not carry a protected-body capability across that body boundary. |
| modal | [return_escape_neg.cj](deferred-modal/modal/return_escape_neg.cj.disabled) | §3.3.3, §4.4 | reject | A value must not carry a protected-body capability across that body boundary. |
| modal | [capturing_instance.cj](deferred-modal/modal/capturing_instance.cj.disabled) | §3.9, §4.4.5 | run | A capturing constructor receives evidence; its clause-free method uses the capture through an interface. |
| modal | [bound_method_escape_neg.cj](deferred-modal/modal/bound_method_escape_neg.cj.disabled) | §3.5, §3.9, §4.4.1 | reject | Bound methods preserve their capturing receivers through a nominal upcast. |
| modal | [internal_storage.cj](deferred-modal/modal/internal_storage.cj.disabled) | §4.4.6 | run | A local! argument originating inside the protected body may accompany a captured capability. |
| modal | [external_storage_alias_neg.cj](deferred-modal/modal/external_storage_alias_neg.cj.disabled) | §4.4.6 | reject | An alias declared inside a try does not make outer mutable storage internal. |
| effects | [captured_handler_escape_neg.cj](deferred-modal/effects/captured_handler_escape_neg.cj.disabled) | §4.4, §5.4 | reject | Effect capabilities obey the same protected-body escape rule as exception capabilities. |
| modal | [capturing_extension.cj](deferred-modal/modal/capturing_extension.cj.disabled) | §3.9.3 | run | An extension method uses the receiver capture without requiring a caller capability. |
| modal | [capturing_static_neg.cj](deferred-modal/modal/capturing_static_neg.cj.disabled) | §3.9.3 | reject | A capturing class does not supply capabilities to static methods. |
| modal | [unchecked_capture_class_neg.cj](deferred-modal/modal/unchecked_capture_class_neg.cj.disabled) | §3.9, §5.1.2 | reject | An unchecked specialization removes a construction obligation, not the capturing class mode. |
| modal | [resolved_mode_overload.cj](deferred-modal/modal/resolved_mode_overload.cj.disabled) | §3.5, §3.7, §5.3.3 | run | An already synthesized capture mode determines an unambiguous ordinary mode overload. |

## Existing section-specific regression coverage

The new cases focus on scheduling and interactions that post-Sema repair misses. Run the existing suites as well; the table makes the remaining coverage obligations explicit.

| Design rule | Existing fixtures/groups to retain or migrate |
|---|---|
| §3.1 capability variance and dynamic handlers | `types/subtype_positive.cj`, `types/subtype_neg.cj`, `scopes/dynamic_handler.cj`, `scopes/catch_wildcard.cj` |
| §3.2 declaration positions, empty/duplicate lists, canonical forms | `parse/`, `types/semantic_form*.cj`, `types/order_identity.cj`, `types/where_bound*.cj` |
| §3.3 supply boundaries, defaults, implicit operations | `scopes/`, `inference/infer_field_initializer.cj`; iterator/resource tests currently using warn must retain their specific demand assertions during migration |
| §3.3.4 non-denotable capabilities | Dedicated non-denotability case in `contracts/capability_not_value_neg.cj` |
| §3.4–6 subtyping, joins/meets, generic substitution | `types/join_meet.cj`, `types/covered_meet.cj`, `types/generics_*.cj`, `inference/infer_ref_generic.cj` |
| §3.7 recursive clause erasure for overload identity | `types/overload_dup.cj`, `types/overload_functype_dup.cj`; available handlers must not select another overload |
| §3.8 overriding after substitution and normalization | `types/override_*.cj`, `types/prop_accessor_generic*.cj`, `inference/infer_override_neg.cj` |
| §3.9 capturing classes and subclass coverage | `captures/`; retain ordinary constructors and receivers under §6.5; mode migration is deferred |
| §3.10 erased ABI, reflection and casts | `abi/erasure_symbols.cj`, the cast/reflection fixtures in `types/`, `serialization/` |
| §4 protected-body confinement | Deferred specifications under `deferred-modal/`; no escape checks are part of the active gate |
| §5.1 unchecked/static classification and assumptions | `unchecked/`, `types/unchecked_instantiated_value.cj`, `scopes/escape_hatch*.cj` |
| §5.2 aliases, flattening, invalid entries and cycles | `aliases/`, canonical type tests, alias serialization cases |
| §5.3 eligibility, authoritative clauses, local functions | `inference/`; the former recursion-positive case now has written clauses on recursive groups |
| §5.4 effect demands, kinds, scopes and resumptions | `performs/`, `compiler/Sema/effect`, and new `effects/` |

The active suite does not settle Modal syntax, capture-dependent modes, mode-overload policy, or origin-flow behavior. Those belong to a later integration task. Multiplatform clause equality is separately covered by `types/cjmp_matching.cj` and `types/cjmp_matching_neg.cj`; these tests are an acceptance floor, not an exhaustiveness claim.

## Historical baseline — 2026-10-09

The installed non-Modal prototype (`cjc 1.0.0`, executable SHA-256 `af64fa7a83dee3808611a5a6469d37d6e7a7087565db3f9ef36fd3748b060776`) was rerun through the existing LLT harness after deferral: exactly 45 active cases were discovered, with 28 passes, 17 failures, and no unresolved executions. The compiler checkout was `5c74df60`; the executable hash identifies the binary actually tested rather than assuming its provenance from the checkout. The harness ran directly against the installed SDK on the host, using Python's fork start method to avoid the host's restricted forkserver socket.

| Active group | Pass | Fail | What the failures establish |
|---|---:|---:|---|
| New `contracts` | 20 | 9 | Seven inference/propagation/site failures; two property-header syntax prerequisites. Includes the mode-independent unchecked-lambda control. |
| New `cycles` | 2 | 7 | The prototype still accepts inferred cycles; annotated recursion and ordinary return-type cycle rejection pass. |
| New `effects` | 5 | 0 | Clause and handler-scope checks pass. |
| Updated legacy recursion fixtures | 1 | 1 | Written-contract recursion passes; growing generic recursion reports the old generic-instantiation failure rather than the scheduler's cycle diagnostic. |
| **Historical active total** | **28** | **17** | **45 cases, including 43 new cases; all active failures remain rewrite requirements.** |

Before Modal deferral, the historical run included all 64 new specifications plus the two recursion fixtures: 28 passed and 38 failed, with no unresolved executions. The 21 now-deferred cases accounted for 21 failures: three capture-mode negatives were accepted and eighteen cases required Modal syntax/integration. These historical outcomes are not current rewrite defects or acceptance gates.

All four written-clause equivalence controls (`written_equivalent` and the three `*_written` cases) compile and execute successfully. Their inferred counterparts expose the current architecture's failures. `missing_join_neg` is rejected inside the inferred function instead of at its under-supplied caller; rejection alone therefore does not pass that test. `long_dependency_chain_neg` is incorrectly accepted. Deferred Modal behavior remains unverified until a compiler integrating both proposals is available.

The following per-case inventory preserves the baseline. Active failures must become passes; deferred entries record historical results only:

| Case | Current result |
|---|---|
| [contracts/order_callers_first.cj](contracts/order_callers_first.cj) | FAIL |
| [contracts/order_callees_first.cj](contracts/order_callees_first.cj) | FAIL |
| [contracts/written_equivalent.cj](contracts/written_equivalent.cj) | PASS |
| [contracts/generic_values.cj](contracts/generic_values.cj) | FAIL |
| [contracts/patterns_and_results.cj](contracts/patterns_and_results.cj) | FAIL |
| [contracts/canonical_and_meet.cj](contracts/canonical_and_meet.cj) | PASS |
| [contracts/members_defaults_fields.cj](contracts/members_defaults_fields.cj) | FAIL |
| [contracts/authoritative_and_dots.cj](contracts/authoritative_and_dots.cj) | PASS |
| [contracts/unchecked_and_assumption.cj](contracts/unchecked_and_assumption.cj) | PASS |
| [contracts/missing_join_neg.cj](contracts/missing_join_neg.cj) | FAIL |
| [contracts/formed_value_neg.cj](contracts/formed_value_neg.cj) | PASS |
| [contracts/generic_invariant_neg.cj](contracts/generic_invariant_neg.cj) | PASS |
| [contracts/result_neg.cj](contracts/result_neg.cj) | PASS |
| [contracts/authoritative_body_neg.cj](contracts/authoritative_body_neg.cj) | PASS |
| [contracts/clause_only_generic_neg.cj](contracts/clause_only_generic_neg.cj) | PASS |
| [contracts/overload_handlers_neg.cj](contracts/overload_handlers_neg.cj) | PASS |
| [contracts/inferred_override_neg.cj](contracts/inferred_override_neg.cj) | PASS |
| [contracts/long_dependency_chain_neg.cj](contracts/long_dependency_chain_neg.cj) | FAIL |
| [cycles/self_neg.cj](cycles/self_neg.cj) | FAIL |
| [cycles/empty_self_neg.cj](cycles/empty_self_neg.cj) | FAIL |
| [cycles/mutual_neg.cj](cycles/mutual_neg.cj) | FAIL |
| [cycles/value_edge_neg.cj](cycles/value_edge_neg.cj) | FAIL |
| [cycles/handled_cycle_neg.cj](cycles/handled_cycle_neg.cj) | FAIL |
| [cycles/ellipsis_cycle_neg.cj](cycles/ellipsis_cycle_neg.cj) | FAIL |
| [cycles/local_cycle_neg.cj](cycles/local_cycle_neg.cj) | FAIL |
| [cycles/partial_contract_neg.cj](cycles/partial_contract_neg.cj) | PASS |
| [cycles/annotated_and_cut.cj](cycles/annotated_and_cut.cj) | PASS |
| [deferred-modal/modal/capture_modes.cj.disabled](deferred-modal/modal/capture_modes.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/outer_origin_and_dynamic_handler.cj.disabled](deferred-modal/modal/outer_origin_and_dynamic_handler.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/local_aggregate.cj.disabled](deferred-modal/modal/local_aggregate.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/unrestricted_capture_neg.cj.disabled](deferred-modal/modal/unrestricted_capture_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/ordinary_transitive_capture_neg.cj.disabled](deferred-modal/modal/ordinary_transitive_capture_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/escaping_parameter_neg.cj.disabled](deferred-modal/modal/escaping_parameter_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/outward_assignment_neg.cj.disabled](deferred-modal/modal/outward_assignment_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/call_tuple_escape_neg.cj.disabled](deferred-modal/modal/call_tuple_escape_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/innermost_supply_neg.cj.disabled](deferred-modal/modal/innermost_supply_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/inner_origin_neg.cj.disabled](deferred-modal/modal/inner_origin_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/aggregate_try_result_neg.cj.disabled](deferred-modal/modal/aggregate_try_result_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/return_escape_neg.cj.disabled](deferred-modal/modal/return_escape_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/capturing_instance.cj.disabled](deferred-modal/modal/capturing_instance.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/bound_method_escape_neg.cj.disabled](deferred-modal/modal/bound_method_escape_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/internal_storage.cj.disabled](deferred-modal/modal/internal_storage.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/external_storage_alias_neg.cj.disabled](deferred-modal/modal/external_storage_alias_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [effects/mixed_requirements.cj](effects/mixed_requirements.cj) | PASS |
| [effects/no_effect_inference_neg.cj](effects/no_effect_inference_neg.cj) | PASS |
| [effects/resume_sibling_catch.cj](effects/resume_sibling_catch.cj) | PASS |
| [effects/handler_body_scope_neg.cj](effects/handler_body_scope_neg.cj) | PASS |
| [deferred-modal/effects/captured_handler_escape_neg.cj.disabled](deferred-modal/effects/captured_handler_escape_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [contracts/property_header.cj](contracts/property_header.cj) | FAIL |
| [contracts/property_header_neg.cj](contracts/property_header_neg.cj) | FAIL |
| [contracts/catch_finally_scope_neg.cj](contracts/catch_finally_scope_neg.cj) | PASS |
| [contracts/static_initializer_neg.cj](contracts/static_initializer_neg.cj) | PASS |
| [deferred-modal/modal/capturing_extension.cj.disabled](deferred-modal/modal/capturing_extension.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/capturing_static_neg.cj.disabled](deferred-modal/modal/capturing_static_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [deferred-modal/modal/unchecked_capture_class_neg.cj.disabled](deferred-modal/modal/unchecked_capture_class_neg.cj.disabled) | DEFERRED (historical FAIL) |
| [contracts/unchecked_lambda.cj](contracts/unchecked_lambda.cj) | PASS |
| [effects/expected_literal.cj](effects/expected_literal.cj) | PASS |
| [contracts/generic_values_written.cj](contracts/generic_values_written.cj) | PASS |
| [contracts/patterns_and_results_written.cj](contracts/patterns_and_results_written.cj) | PASS |
| [contracts/members_defaults_fields_written.cj](contracts/members_defaults_fields_written.cj) | PASS |
| [deferred-modal/modal/resolved_mode_overload.cj.disabled](deferred-modal/modal/resolved_mode_overload.cj.disabled) | DEFERRED (historical FAIL) |
| [contracts/nominal_projection.cj](contracts/nominal_projection.cj) | PASS |
| [contracts/capability_not_value_neg.cj](contracts/capability_not_value_neg.cj) | PASS |
| [contracts/dependency_scope_isolation_neg.cj](contracts/dependency_scope_isolation_neg.cj) | PASS |

## Migration regressions

The migration adds omitted-clause lexical capture and recursion cases, tuple return clauses, generic callback and constructor use, structured macro contract round trips, written/inferred warning and error twins, discarded generic overloads, dynamic `This` method references, repeated failed-contract consumers under speculative checking, mixed concrete/abstract accessors, and incremental shrinking through an unused nested body. These additions are active acceptance tests; the historical baseline counts above do not limit the gate. Final acceptance on 2026-10-12 passes all 105 active rewrite drivers, all 295 checked-exceptions/effect drivers, all 6,315 configured broad integration drivers, and all 49 compiler unit suites. Both std and stdx were rebuilt at warning level with that compiler. Compiler identity and logs are recorded in the workspace gap ledger.
