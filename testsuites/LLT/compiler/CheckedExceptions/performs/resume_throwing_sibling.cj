// Effects (rule 5 of "Effect requirements"): 'resume throwing e' injects 'e' at the suspended
// 'perform' site, which is inside the try's own body — so the try's own catch clauses discharge
// it. This is the text's own positive example; before the rule it was rejected, since the handler
// body was checked against the enclosing scopes alone.

// EXEC: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %set_stdx_path %run_opt %output

import stdx.effect.*

class GetLogger <: Command<Int64> {}
class LoggerUnavailable <: Exception {}

func f(): Int64
performs GetLogger {
    return perform GetLogger()
}

public func caller(): Int64
throws () {
    try {
        return f()
    } catch (e: LoggerUnavailable) {
        return 7          // the injected exception surfaces at the perform, inside this try
    } handle (_: GetLogger) {
        resume throwing LoggerUnavailable()
    }
}

main(): Int64 {
    if (caller() != 7) {
        return 1
    }
    return 0
}
