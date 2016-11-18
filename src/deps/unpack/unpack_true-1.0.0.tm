proc ::MessagePack::unpacking::true {char binary_string previous_result} {
    if {$char == 0xC3} {
        set tmp_result 1
        set result [::MessagePack::unpacking::wrapResult $tmp_result "bool" $params]
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}
