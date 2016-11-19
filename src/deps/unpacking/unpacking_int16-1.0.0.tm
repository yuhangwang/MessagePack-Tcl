proc ::MessagePack::unpacking::int16 {char binary_string params previous_result} {
    if {$char == 0xD1} {
        if {[::MessagePack::isStringLongEnough $binary_string 2]} {
            binary scan $binary_string "S" tmp_result
            set binary_string [string range $binary_string 2 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "int16" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
