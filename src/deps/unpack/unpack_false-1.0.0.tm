proc ::MessagePack::unpack::false {char binary_string final_result} {
    if {$char == 0xC2} {
        return 0
    } else {
        return [list $char $binary_string $final_result]
    }
}
