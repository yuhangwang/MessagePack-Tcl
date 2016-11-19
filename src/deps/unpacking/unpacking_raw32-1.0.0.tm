proc ::MessagePack::unpacking::raw32 {char binary_string params previous_result} {
    if {$char == 0xDB} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            binary scan $binary_string "I" tmp_n
            set n [expr {$tmp_n & 0xFFFFFFFF}]
            set binary_string [string range $binary_string 4 end]

            # scan n bytes
            if {[::MessagePack:isStringLongEnough $binary_string $n]} {
                binary scan $binary_string "a$n" tmp_result
                set binary_string [string range $binary_string $n end]
            } else {
                set tmp_result $previous_result
            }

            set result [::MessagePack::unpacking::wrapResult $tmp_result "string" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
