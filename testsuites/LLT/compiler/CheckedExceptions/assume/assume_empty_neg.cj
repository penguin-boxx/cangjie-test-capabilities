// Checked exceptions (assumption imports): the empty list is rejected -- an assumption that assumes
// nothing is either a mistake or the bare form written the long way, and the bare form already
// means 'Exception'.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: '@AssumeThrows[]' assumes nothing

@AssumeThrows[]
import std.collection.*

main() {
    return 0
}
