proc ::MessagePack::unpack::negative_fixnum {char binary_string params previous_result} {
    if {($char & 0xE0) >= 0xE0} {
        binary scan [binary format "c" [expr {($char & 0x1F) | 0xE0}]] "c" tmp_result

        if {[dict get $params showDataType]} {
            set result [list "negative_fixnum" $tmp_result]
        } else {
            set result $tmp_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}