proc ::MessagePack::unpacking::nil {char binary_string params previous_result} {
    if {$char == 0xC0} {
        set tmp_result "nil"
        set result [::MessagePack::unpacking::wrapResult $tmp_result "double" $params]
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
