// Checked exceptions ("Reflection and runtime casts"): a clause-bearing functional type and its
// erased shape are one runtime type with one identity -- 'TypeInfo' of '() throws E -> Unit' IS
// that of '() -> Unit', of a value of the clause-bearing type too, and prints without a trace of
// the clause. Reflective construction is an unchecked boundary: the capability fields are erased,
// so constructing a capturing type succeeds. The text's own examples; correct since erasure landed,
// and untested until now.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import std.reflect.*

public class AException <: Exception {}

public class Capturing captures AException {
    public init() {}
}

main(): Int64 {
    let withClause = TypeInfo.of<() throws AException -> Unit>()
    let without = TypeInfo.of<() -> Unit>()
    let value: () throws AException -> Unit = { => throw AException() }
    if (withClause != without || TypeInfo.of(value) != without || withClause.toString() != without.toString() ||
        withClause.toString().contains("throws")) {
        return 1
    }
    // (Checked through reflection only: a capturing type is not a runtime cast target.)
    let info = ClassTypeInfo.of<Capturing>()
    let instance = info.construct()
    return if (TypeInfo.of(instance) == info) { 0 } else { 2 }
}
