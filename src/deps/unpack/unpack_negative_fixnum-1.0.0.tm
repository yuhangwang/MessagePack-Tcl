proc ::MessagePack::unpacking::negative_fixnum {char binary_string params previous_result} {
    if {($char & 0xE0) >= 0xE0} {
        binary scan [binary format "c" [expr {($char & 0x1F) | 0xE0}]] "c" tmp_result
        set result [::MessagePack::unpacking::wrapResult $tmp_result "negative_fixnum" $params]
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}