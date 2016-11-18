proc ::MessagePack::unpack::false {char binary_string params previous_result} {
    if {$char == 0xC2} {
        if {[dict get $params showDataType]} {
            set result {"bool" 0}
        } else {
            set result 0
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
