// Checked exceptions (capability parameters in declarations): no capability scope encloses a
// finalizer -- it may run long after the handlers that supplied the capabilities are gone -- so a
// finalizer carries no `throws` clause. The scope side of the rule is in scopes/neg_finalizer.cj.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: a 'throws' clause is not allowed on a finalizer

class AException <: Exception {}

func mkA() throws AException {
    throw AException()
}

class WithClause {
    ~init() throws AException {
        mkA()
    }
}

main() {
    return 0
}
