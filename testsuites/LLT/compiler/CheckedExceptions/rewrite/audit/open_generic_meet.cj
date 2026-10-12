// Rewrite audit: §3.4.3, §3.6.
// Unrelated open exception variables contribute no common entry to the meet in parameter position.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}
class Box<T> { let value: T; init(value: T) { this.value = value } }
func choose<E1, E2>(a: (() throws E1 -> Unit) -> Unit, b: (() throws E2 -> Unit) -> Unit, flag: Bool): (() -> Unit) -> Unit
where E1 <: Exception, E2 <: Exception {
    let joined = if (flag) { a } else { b }
    let exact: Box<(() -> Unit) -> Unit> = Box(joined)
    exact.value
}
func a(f: () throws AE -> Unit): Unit {}
func b(f: () throws BE -> Unit): Unit {}
main(): Int64 {
    choose<AE, BE>(a, b, true)({ => })
    return 0
}
