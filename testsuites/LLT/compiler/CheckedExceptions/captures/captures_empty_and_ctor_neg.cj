// Checked exceptions (capability capturing rules 1 and 2): a `captures` clause that is statically
// empty -- written `()`, or an alias that expands to nothing -- is equivalent to omitting it, so
// `Empty` below is an ordinary non-capturing class. A capturing type, by contrast, has no implicit
// default constructor: every constructor requires the captured capabilities at its call site, so
// there must be one to carry the requirement.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: class 'NoCtor' has a 'captures' clause and must declare an 'init' constructor

class FileException <: Exception {}

// statically empty: not capturing, so the ordinary constructor rules apply
class Empty
captures () {
    Empty(let x: Int64) {} // a primary constructor is fine here
}

class NoCtor
captures FileException {
    public func write(s: String): Unit {
        throw FileException()
    }
}

main() {
    let e = Empty(1)
    return 0
}
