// Checked exceptions (capability parameters in declarations): no capability scope encloses a static
// initializer -- it runs during global initialization, where no caller supplies anything -- so, like
// a finalizer, it carries no 'throws' clause. The scope side of the rule is in
// scopes/neg_static_init.cj.
//
// Before, the clause was accepted and its entries supplied the block's body, so the checked throw
// below compiled at 'error' and escaped from the global initializer.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: a 'throws' clause is not allowed on a static initializer

class AException <: Exception {}

class WithClause {
    static var y: Int64 = 0
    static init() throws AException {
        throw AException()
    }
}

main(): Int64 {
    return 0
}
