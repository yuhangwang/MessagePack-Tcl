proc ::MessagePack::unpacking::true {char binary_string final_result} {
    if {$char == 0xC3} {
        return 1
    } else {
        return [list $char $binary_string $final_result]
    }
}
