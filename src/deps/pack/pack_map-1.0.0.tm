proc ::MessagePack::pack::map {value} {
    if {$value < 16} {
        return [binary format "c" [expr {0x80 | $value}]]
    } elseif {$value < 65536} {
        return [binary format "cS" 0xDE $value]
    } else {
        return [binary format "cI" 0xDF $value]
    }
}
