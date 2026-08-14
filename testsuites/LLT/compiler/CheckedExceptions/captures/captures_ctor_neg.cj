// Checked exceptions (§3.9): constructing a capturing class demands the captured
// capabilities at the construction site — no suitable capability, no instance.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-FileException'
// ASSERT: scan required by the call to 'init'

class FileException <: Exception {}

class FileWriter
captures FileException {
    init() {
    }

    func append(s: String): Unit {
        throw FileException()
    }
}

main() {
    let w = FileWriter() // error: no FileException capability in scope
    w.append("x")
    return 0
}
