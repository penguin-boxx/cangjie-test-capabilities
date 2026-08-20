// Checked exceptions (functional types/interaction with an explicit throws): the `...` marker never appears in functional
// types — a functional type's capability list is always complete.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: '...' is not allowed in a function type's 'throws' clause

class AException <: Exception {}

var f: () throws (AException, ...) -> Unit = { => () }

main() {
    return 0
}
