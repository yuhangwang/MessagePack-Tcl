proc ::MessagePack::pack::markArraySize {value} { 
    if {$value < 16} {
        return [binary format c [expr {0x90 | $value}]]
    } elseif {$value < 65536} {
        return [binary format cS 0xDC $value]
    } else {
        return [binary format cI 0xDD $value]
    }
}
