proc ::MessagePack::unpacking::fixmap {char binary_string params previous_result} {
    if {$char >= 0x80 && $char <= 0x8F} {
        set n [expr {$char & 0xF}]
        set accum {}
        for {set i 0} {$i < $n} {incr i} {
            foreach i {1 2} {
                lassign [::MessagePack::unpack_aux $binary_string] tmp_result binary_string
                lappend accum $tmp_result
            }
        }
        if {[dict get $params showDataType]} {
            set result [list "fixmap" $accum]
        } else {
            set result $accum
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}