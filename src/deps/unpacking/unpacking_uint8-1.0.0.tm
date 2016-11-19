proc ::MessagePack::unpacking::uint8 {char binary_string params previous_result} {
    if {$char == 0xCC} {
        if {[::MessagePack::isStringLongEnough $binary_string 1]} {
            binary scan $binary_string "c" tmp_value
            set tmp_result [expr {$tmp_value & 0xFF}]
            set binary_string [string range $binary_string 1 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "uint8" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
