// Checked exceptions (the escape hatch): instantiating it with an unchecked type is a no-op --
// throwing an unchecked exception never required a capability -- so the call is warned about,
// in the 'checked-exceptions' group.

// EXEC-PIPE: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan warning: 'unsafeCanThrow' assumes 'Class-MyUnchecked', which is unchecked

class MyUnchecked <: UncheckedException {}

func nothingToAssume(): Int64 {
    unsafeCanThrow<MyUnchecked, Int64>({ => 1 })
}

main() {
    return nothingToAssume() - 1
}
