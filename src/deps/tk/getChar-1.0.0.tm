## consume a char (8-bit integer) and return {data result}
# where the $data is the truncated input binary string by one char
# and $result is the result of [expr {$char & 0xFF}]
proc getChar {binary_string} {
    if {[::MessagePack::isStringLongEnough $binary_string, 1]} {
        binary scan $binary_string "c" var
        return [list [expr {$var & 0xFF}] [string range $binary_string 1 end]]
    } else {
        return [list "" $binary_string]
    }
}