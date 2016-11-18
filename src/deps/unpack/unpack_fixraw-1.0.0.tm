proc ::MessagePack::unpacking::fixraw {char binary_string params previous_result} {
    if {$char >= 0xA0 && $char <= 0xBF} {
        set n [expr {$char & 0x1F}]
        if {[::MessagePack::isStringLongEnough $binary_string $n]} {
            binary scan $binary_string "a$n" tmp_result
            set binary_string [string range $binary_string $n end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "fixraw" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}
