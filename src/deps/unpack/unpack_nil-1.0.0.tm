proc ::MessagePack::unpack::nil {char binary_string params previous_result} {
    if {$char == 0xC0} {
        if {[dict get $params showDataType]} {
            set result [list "nil" "nil"]
        } else {
            set result "nil"
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}
