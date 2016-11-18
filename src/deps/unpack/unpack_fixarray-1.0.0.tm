proc ::MessagePack::unpack::fixarray {char binary_string params previous_result} {
    if {$char >= 0x90 && $char <= 0x9F} {
        set n [expr {$char & 0xF}]
        set accum {}
        for {set i 0} {$i < $n} {incr i} {
            lassign [::MessagePack::unpack_aux $binary_string] tmp_result binary_string
            lappend accum $tmp_result
        }
        
        if {[dict get $params showDataType]} {
            set result [list "fixarray" $accum]
        } else {
            set result $accum
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}