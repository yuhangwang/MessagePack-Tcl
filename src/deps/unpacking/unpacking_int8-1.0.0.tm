proc ::MessagePack::unpacking::int8 {char binary_string params previous_result} {
    if {$char == 0xD0} {
        if {[::MessagePack::isStringLongEnough $binary_string 1]} {
            binary scan $binary_string "c" tmp_result
            set binary_string [string range $binary_string 1 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "int8" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
