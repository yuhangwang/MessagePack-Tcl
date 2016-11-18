proc ::MessagePack::unpack::float {char binary_string params previous_result} {
    if {$char == 0xCA} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            binary scan $binary_string "R" tmp_result
            set binary_string [string range $binary_string 4 end]

            if {[dict get $params showDataType]} {
                set result [list "float" $tmp_result]
            } else {
                set result $tmp_result
            }

        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
