// Support file for assume_package_scope_neg.cj: the same package, a plain import, and a callable
// that pins an empty capability list. The assumption written in the other file reaches this call.

import legacy_db.*

func inOtherFile(): Int64 throws () {
    query("select 1")
}
