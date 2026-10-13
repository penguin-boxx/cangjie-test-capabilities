// Section 6 acceptance: §6.1: functional casts follow effect warn with exceptions off.
// EXEC-PIPE: %compiler %cmp_opt %enableEH --enable-checked-effects warn  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex warning:.*(runtime cast target|function type)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: scan-not error:
// EXEC: %run %output

func cast(value: Any): Unit { let result = value as (() -> Unit) }
main(): Int64 { 0 }
