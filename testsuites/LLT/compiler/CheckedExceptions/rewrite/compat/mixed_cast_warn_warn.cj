// Identical cast diagnostics at one site remain visible in both warning groups.
// EXEC-PIPE: %compiler %cmp_opt %enableEH -Woff unused --enable-checked-exceptions warn --enable-checked-effects warn %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan 2 warnings generated
// ASSERT: scan -Woff checked-exceptions
// ASSERT: scan -Woff checked-effects
// ASSERT: scan-not error:
// EXEC: %run %output

public func cast(value: Any) { value as (() -> Unit) }
main(): Int64 { 0 }
