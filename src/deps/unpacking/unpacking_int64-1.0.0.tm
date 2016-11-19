proc ::MessagePack::unpacking::int64 {char binary_string params previous_result} {
    if {$char == 0xD3} {
        if {[::MessagePack::isStringLongEnough $binary_string 8]} {
            binary scan $binary_string "W" tmp_result
            set binary_string [string range $binary_string 8 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "int64" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
