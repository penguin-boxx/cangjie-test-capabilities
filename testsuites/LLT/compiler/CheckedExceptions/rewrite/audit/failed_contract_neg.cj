// Speculative reference checking must report an inferred declaration's ordinary body error.
// Repeated consumers of its failed contract must not recover a provisional empty signature.
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=warn %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: mismatched types
// ASSERT: scan expected 'Int64', found 'Struct-String'
// ASSERT: scan-not recursive capability inference
// ASSERT: scan-not Internal Compiler Error
func invoke(f: () -> Int64): Int64 { f() }
func first(): Int64 { invoke(broken) }
func second(): Int64 { invoke(broken) }
func broken(): Int64 { "invalid result" }
main(): Int64 { first() + second() }
