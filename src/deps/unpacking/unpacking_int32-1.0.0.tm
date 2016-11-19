proc ::MessagePack::unpacking::int32 {char binary_string params previous_result} {
    if {$char == 0xD2} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            binary scan $binary_string "I" tmp_result
            set binary_string [string range $binary_string 4 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "int32" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
