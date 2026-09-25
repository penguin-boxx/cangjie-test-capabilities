// Checked exceptions ("Runtime ABI"): a clause-bearing functional type and its erased form are one
// runtime type, so two instantiations of a generic declaration whose type arguments differ only in
// capability lists are one instantiation. They share a runtime shape and a mangled name; building
// two declarations under one symbol is what crashed the back end.
//
// Before, the compiler aborted after CHIR ('_Map_base::at', or a segmentation fault) on each program
// below: at the default level through the standard library's 'const init' of 'Array', which is
// always instantiated, and at '-O2' through any generic declaration, which is then instantiated
// too. Array literals and non-'const' generics at the default level were unaffected, which is why
// the crash went unnoticed.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions -O2 %n.cj -o %output
// EXEC: %run %output

class E1 <: Exception {}
class E2 <: Exception {}

class Box<T> {
    var held: Option<T> = None
    init() {}
}

struct ConstBox<T> {
    let size: Int64
    const init() { size = 0 }
}

main(): Int64 {
    // the standard library's 'const init', at a throwing, a differently throwing and an erased type
    let a1 = Array<() throws E1 -> Unit>()
    let a2 = Array<() throws E2 -> Unit>()
    let a3 = Array<() -> Unit>()
    // a user 'const init', the same three ways
    let c1 = ConstBox<() throws E1 -> Unit>()
    let c2 = ConstBox<() throws E2 -> Unit>()
    let c3 = ConstBox<() -> Unit>()
    // an ordinary generic class -- instantiated at '-O2'
    let b1 = Box<() throws (E1, E2) -> Unit>()
    let b2 = Box<() -> Unit>()
    b2.held = Some({ => })
    return a1.size + a2.size + a3.size + c1.size + c2.size + c3.size + (if (b1.held.isNone()) { 0 } else { 1 })
}
