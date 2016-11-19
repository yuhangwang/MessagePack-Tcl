proc ::MessagePack::unpacking::array16 {char binary_string params previous_result} {
    if {$char == 0xDC} {
        if {[::MessagePack::isStringLongEnough $binary_string 2]} {
            binary scan $binary_string "S" tmp_n
            set n [expr {$tmp_n & 0xFFFF}]
            set binary_string [string range $binary_string 2 end]

            set tmp_result {}
            for {set i 0} {$i < $n} {incr i} {
                lassign [::MessagePack::unpacking::aux $binary_string $params] tmp_value binary_string
                lappend tmp_result $tmp_value
            }
            set result $tmp_result
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
