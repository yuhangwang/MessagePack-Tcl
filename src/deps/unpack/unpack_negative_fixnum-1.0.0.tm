proc ::MessagePack::unpack::negative_fixnum {char binary_string final_result} {
    if {($char & 0xE0) >= 0xE0} {
        binary scan [binary format "c" [expr {($char & 0x1F) | 0xE0}]] "c" result
        return [list $char $binary_string $result]
    } else {
        return [list $char $binary_string $final_result]
    }
}