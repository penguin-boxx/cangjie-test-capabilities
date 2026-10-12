// Deriving emits mutually recursive validation helpers with complete contracts.
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import std.deriving.Derive

@Derive[Equatable]
@Derive[ToString]
enum Item {
    Empty | Value(UInt8)
}
main(): Int64 {
    let item = Item.Value(7)
    if (item != Item.Value(7) || item.toString().isEmpty()) { return 1 }
    return 0
}
