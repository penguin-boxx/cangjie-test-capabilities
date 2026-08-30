// Checked exceptions ("ABI and reflection"): capability parameters are stripped after type
// checking -- a declaration with a clause lowers exactly as one without, function values share
// the representation of their erased counterpart, and no capability object is ever materialized.
// Argued from the architecture ('capTys' sit outside 'typeArgs', so CHIR and codegen never see
// them) but never pinned by a test until the 2026-08-30 review asked for one.
//
// The two dependencies are the same package written with and without clauses. Compiled to static
// libraries, their symbol tables must be byte-identical -- name, type and all.

// DEPENDENCE: erasure_symbols_lib.cj erasure_symbols_plain.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions erasure_symbols_lib.cj -o with_clauses.%middle
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions erasure_symbols_plain.cj -o without_clauses.%middle
// EXEC-PIPE: nm with_clauses.%middle | awk '{print $2, $3}' | sort > with.txt; nm without_clauses.%middle | awk '{print $2, $3}' | sort > without.txt; diff with.txt without.txt && echo ERASURE_IDENTICAL | compare %f
// ASSERT: scan ERASURE_IDENTICAL

main(): Int64 { 0 }
