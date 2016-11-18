proc ::MessagePack::unpack::positive_fixnum {char binary_string final_result} {
    if {$char < 0x80} {
        return [list $char $binary_string [expr {$char & 0x7F}]]
    } else {
        return [list $char $binary_string $final_result]
    }
}