proc ::MessagePack::pack::raw {value} {
    if {$value < 32} {
        return [binary format c [expr {0xA0 | $value}]]
    } elseif {$value < 65536} {
        return [binary format cS 0xDA $value]
    } else {
        return [binary format cI 0xDB $value]
    }
}