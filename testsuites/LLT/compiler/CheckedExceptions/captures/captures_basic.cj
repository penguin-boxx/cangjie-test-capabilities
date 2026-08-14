// Checked exceptions (§3.9, pre-Modal semantics per author ruling): a `captures`
// clause on a class makes EVERY constructor demand the captured capabilities at
// its call site, and puts them in scope in EVERY method/prop body.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class FileException <: Exception {}

class FileWriter
captures FileException {
    var count: Int64 = 0

    init() {
    }

    func append(s: String): Unit {
        count = count + s.size
        if (count > 100) {
            throw FileException() // captured capability is in scope
        }
    }

    prop total: Int64 {
        get() {
            if (count < 0) {
                throw FileException() // in scope in accessors too
            }
            count
        }
    }
}

main() {
    try {
        let w = FileWriter() // ctor demands the capability from this try
        w.append("hello")
        if (w.total != 5) {
            return 1
        }
    } catch (e: FileException) {
    }
    return 0
}
