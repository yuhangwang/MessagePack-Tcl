proc ::MessagePack::unpacking::positive_fixnum {char binary_string params previous_result} {
    if {$char < 0x80} {
        set tmp_result [expr {$char & 0x7F}]
        set result [::MessagePack::unpacking::wrapResult $tmp_result "positive_fixnum" $params]
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}