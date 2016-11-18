proc ::MessagePack::unpacking::false {char binary_string params previous_result} {
    if {$char == 0xC2} {
        set tmp_result 0
        set result [::MessagePack::unpacking::wrapResult $tmp_result "bool" $params]
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
