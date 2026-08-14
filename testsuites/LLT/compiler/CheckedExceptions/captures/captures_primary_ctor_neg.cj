// Checked exceptions (§3.9, author ruling): a capturing class may not declare a
// primary constructor (forward-compatible with Modal, where primaries are ~local);
// it declares explicit init constructors.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error

class FileException <: Exception {}

class FileWriter
captures FileException {
    FileWriter(let path: String) { // error: primary ctor on a capturing class
    }
}

main() {
    return 0
}
