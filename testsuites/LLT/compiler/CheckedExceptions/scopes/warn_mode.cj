// Checked exceptions (author ruling): --enable-chexc=warn downgrades capability
// diagnostics to warnings — the program still compiles and runs.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc=warn %n.cj -o %output 2> warn_out.txt
// EXEC: %run %output
// EXEC-PIPE-2: cat warn_out.txt | compare %f
// ASSERT: scan warning: Cannot find a capability for 'AException'

class AException <: Exception {}

func noClause() {
    if (false) {
        throw AException() // warning in warn mode, not an error
    }
}

main() {
    noClause()
    return 0
}
