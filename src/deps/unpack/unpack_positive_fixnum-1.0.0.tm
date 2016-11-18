proc ::MessagePack::unpacking::positive_fixnum {char binary_string params previous_result} {
    if {$char < 0x80} {
        set tmp_result [expr {$char & 0x7F}]
        if {[dict get $params showDataType]} {
            set result [list "positive_fixnum" $tmp_result]
        } else {
            set result $tmp_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}