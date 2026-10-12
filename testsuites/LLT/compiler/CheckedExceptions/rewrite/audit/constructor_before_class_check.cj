// On-use constructor completion checks super-call ordering before body desugaring.
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output
func create(): Child { Child() }
enum Kind { Normal | Other }
open class Parent {
    let value: Int64
    init(position: (Int64, Int64), kind: Kind, optional: ?Int64) {
        value = position[0] + (optional ?? 0)
    }
}
class Child <: Parent {
    init() { super((0, 0), Kind.Normal, None) }
}
main(): Int64 { create().value }
