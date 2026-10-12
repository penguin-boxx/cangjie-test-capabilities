// Checked exceptions: §3.9 under non-Modal §6.5.
// An implicit default constructor is legal under §6.5, but its construction site must supply captures.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-FileException'
// ASSERT: regex-not error:.*(must declare an 'init'|cannot declare a primary|unexpected token|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex captures_empty_and_ctor_neg\.cj:17:[0-9]+:

class FileException <: Exception {}
class Empty captures () { Empty(let x: Int64) {} }
class NoCtor captures FileException {
    func write(): Unit throws () { throw FileException() }
}
main(): Int64 {
    let empty = Empty(1)
    let writer = NoCtor() // ERROR: implicit constructor is legal but requires FileException
    return 0
}
