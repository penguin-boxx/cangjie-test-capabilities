// Checked exceptions (§3.2): `throws` in a declaration must be followed by an
// exception type (or a parenthesized list); a bare clause is a parse error.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: expected exception type after 'throws', found '{'

func f(): Unit throws {
}

main() {
    return 0
}
