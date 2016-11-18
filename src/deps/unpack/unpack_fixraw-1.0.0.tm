proc ::MessagePack::unpack::fixraw {char binary_string final_result} {
    if {$char >= 0xA0 && $char <= 0xBF} {
        set n [expr {$char & 0x1F}]
        if {[::MessagePack::isStringLongEnough $binary_string $n]} {
            binary scan $binary_string "a$n" result
            set binary_string [string range $binary_string $n end]
            return [list $char $binary_string $result]
        } else {
            return [list $char $binary_string $final_result]
        }
    } else {
        return [list $char $binary_string $final_result]
    }
}
