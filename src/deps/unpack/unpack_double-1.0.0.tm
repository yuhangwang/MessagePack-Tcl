proc ::MessagePack::unpacking::double {char binary_string params previous_result} {
    if {$char == 0xCB} {
        if {[::MessagePack::isStringLongEnough $binary_string 8]} {
            binary scan $binary_string "Q" tmp_result
            set binary_string [string range $binary_string 8 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "double" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
