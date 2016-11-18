proc ::MessagePack::unpack::float {char binary_string final_result} {
    if {$char == 0xCA} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            binary scan $binary_string "R" result
            set binary_string [string range $binary_string 4 end]
            return [list $char $binary_string $result]
        } else {
            return [list $char $binary_string $final_result]
        }
    } else {
        return [list $char $binary_string $final_result]
    }
}
