proc ::MessagePack::unpack::nil {char binary_string final_result} {
    if {$char == 0xC0} {
        return "nil"
    } else {
        return [list $char $binary_string $final_result]
    }
}
