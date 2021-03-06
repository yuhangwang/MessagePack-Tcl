proc ::MessagePack::unpacking::fixmap {char binary_string params previous_result} {
    if {$char >= 0x80 && $char <= 0x8F} {
        set n [expr {$char & 0xF}]
        set tmp_result {}
        for {set i 0} {$i < $n} {incr i} {
            foreach _ {1 2} {
                lassign [::MessagePack::unpacking::aux $binary_string $params] value binary_string
                lappend tmp_result $value
            }
        }
        set result $tmp_result
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
