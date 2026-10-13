// Section 6 acceptance: §6.1: specified effect option spelling.
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-effects error  %n.cj -o %output
// EXEC: %run %output

main(): Int64 { 0 }
