proc ::MessagePack::unpacking::fixarray {char binary_string params previous_result} {
    if {$char >= 0x90 && $char <= 0x9F} {
        set n [expr {$char & 0xF}]
        set tmp_result {}
        for {set i 0} {$i < $n} {incr i} {
            lassign [::MessagePack::unpacking::aux $binary_string $params] value binary_string
            lappend tmp_result $value
        }
        set result $tmp_result
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
