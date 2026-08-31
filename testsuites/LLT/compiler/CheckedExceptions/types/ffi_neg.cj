// Checked exceptions (FFI ruling): a `throws` clause is banned on foreign
// functions and on CFunc function types — C code provides no capabilities.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: a 'throws' clause is not allowed on a foreign function
// ASSERT: scan error: a 'throws' clause is not allowed on a 'CFunc' type

class AException <: Exception {}

foreign func fooc(): Unit throws AException

var g: CFunc<() throws AException -> Unit> = { => }

main() {
    return 0
}
