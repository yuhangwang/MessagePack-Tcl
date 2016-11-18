## Check whether the string has length at least "n"
proc isStringLongEnough {str n} {
    if {[string length $str] < $n} {
        puts "ERROR HINT: input binary string not long enough"
        return 0
    } else {
        return 1
    }
}