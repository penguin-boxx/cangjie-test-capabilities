// Checked exceptions: `()` is the empty entry list and is legal only as the whole list -- neither
// nested in nor mixed with other entries.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: '()' is only allowed as the whole capability list

class AException <: Exception {}

func mixed() throws AException, () {
    throw AException()
}

func nested() throws ((), AException) {
    throw AException()
}

main() {
    return 0
}
