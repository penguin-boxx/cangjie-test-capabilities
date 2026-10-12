// A generic candidate excluded by its written bound is not an inference dependency.
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

interface TokenLike { func code(): Int64 }
class Token <: TokenLike { public func code(): Int64 { 7 } }
class Builder {
    func append(value: Builder): Int64 { 3 }
    func append<T>(value: T): Int64 where T <: TokenLike {
        match (value) {
            case builder: Builder => append(builder)
            case _ => value.code()
        }
    }
}
func choose(value: Any): Int64 { choose(1) }
func choose(value: Int64): Int64 { value }
// Function-reference filtering must substitute a dynamic This result before matching.
open class Base {
    func self() { this }
    protected open func code(): Int64 { 1 }
}
class Derived <: Base {
    protected override func code(): Int64 { 2 }
}
main(): Int64 {
    let builder = Builder()
    let derived = Derived()
    let reference: () -> Derived = derived.self
    if (reference().code() != 2) { return 1 }
    return if (builder.append(Token()) == 7 && builder.append(builder) == 3 && choose("unused") == 1) { 0 } else { 1 }
}
