// Rewrite audit: §3.4, §5.4.
// Effect function values preserve joined and canonical requirement lists through generic inference.
//
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*
class AskA <: Command<Int64> {}
class AskB <: Command<Int64> {}
class Box<T> { let value: T; init(value: T) { this.value = value } }
func a(): Int64 performs AskA { perform AskA() }
func b(): Int64 performs AskB { perform AskB() }
func joined(flag: Bool) { if (flag) { a } else { b } }
main(): Int64 {
    let f: Box<() performs (AskB, AskA, AskA) -> Int64> = Box(joined(false))
    let result = try { f.value() } handle (_: AskA) { resume with 1 } handle (_: AskB) { resume with 2 }
    return if (result == 2) { 0 } else { 1 }
}
