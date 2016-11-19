proc ::MessagePack::unpacking::uint64 {char binary_string params previous_result} {
    if {$char == 0xCF} {
        if {[::MessagePack::isStringLongEnough $binary_string 8]} {
            binary scan $binary_string "W" tmp_value
            set tmp_result [expr {$tmp_value & 0xFFFFFFFFFFFFFFFF}]
            set binary_string [string range $binary_string 8 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "uint64" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
