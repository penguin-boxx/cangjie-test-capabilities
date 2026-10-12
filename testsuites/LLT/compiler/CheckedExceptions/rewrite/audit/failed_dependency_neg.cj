// Rewrite audit: §5.3; completion failure and diagnostic suppression.
// A dependency typing failure must remain visible when first encountered through generic inference.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(mismatched types)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex failed_dependency_neg\.cj:12:[0-9]+:

func identity<T>(x: T): T { x }
func caller(): Unit { let value = identity(broken) }
func broken(): Int64 { "wrong" } // ERROR: cannot cache this as a successful contract
main(): Int64 { caller(); 0 }
