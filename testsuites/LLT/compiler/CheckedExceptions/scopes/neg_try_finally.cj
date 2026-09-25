// Checked exceptions ("Capability scopes", rule 1): a 'try' supplies one capability per exception
// type listed in its 'catch' patterns -- so a 'try' with only a 'finally' supplies nothing, and a
// requirement in its block is resolved by the enclosing scopes as if the 'try' were not there. The
// 'finally' block runs, but it handles nothing. Correct since the rule was implemented, and
// untested until now; the location pins the requirement to the call inside the 'try' block.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan neg_try_finally.cj:17:9:
// ASSERT: scan Cannot find a capability for 'Class-AException'

class AException <: Exception {}

public func declared(): Int64 throws AException { throw AException() }

public func finallyOnly(): Int64 throws () {
    try {
        declared()                  // error: 'finally' supplies nothing
    } finally {
        println("finally")
    }
}

// The enclosing scope is what resolves it: this one is fine.
public func finallyInsideClause(): Int64 throws AException {
    try {
        declared()
    } finally {
        println("finally")
    }
}

main(): Int64 {
    return 0
}
