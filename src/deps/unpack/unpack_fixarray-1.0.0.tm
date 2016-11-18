proc ::MessagePack::unpack::fixarray {char binary_string final_result} {
    if {$char >= 0x90 && $char <= 0x9F} {
        set n [expr {$char & 0xF}]
        set result {}
        for {set i 0} {$i < $n} {incr i} {
            lassign [::MessagePack::unpack_aux $binary_string] tmp_result binary_string
            lappend result $tmp_result
        }
        return [list $char $binary_string $result]
    } else {
        return [list $char $binary_string $final_result]
    }
}