// Rewrite audit: §3.10.1, §5.2.6, §5.3.3; signature publication.
// An inferred nested function type and expanded alias agree after package serialization.
//
// DEPENDENCE: auditlib.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions auditlib.cj -o auditlib.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions auditlib.%middle %n.cj -o %output
// EXEC: %run %output

import auditlib.*
class Box<T> { let value: T; init(value: T) { this.value = value } }
main(): Int64 {
    let callback: Box<(Bool) throws Errors -> Unit> = Box(factory())
    var caught = 0
    try { callback.value(true) } catch (e: AE) { caught++ } catch (e: BE) { return 1 }
    try { callback.value(false) } catch (e: AE) { return 2 } catch (e: BE) { caught++ }
    return if (caught == 2) { 0 } else { 3 }
}
