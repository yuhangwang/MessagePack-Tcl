proc ::MessagePack::packing::markArraySize {value} { 
    if {$value < 16} {
        return [binary format c [expr {0x90 | $value}]]
    } elseif {$value < 65536} {
        return [binary format cS 0xDC $value]
    } elseif {$value < 4294967296} {
        return [binary format cI 0xDD $value]
    } else {
        puts stderr "ERROR HINT: array size is bigger than what a 32-bit uint can store"
        return [::MessagePack::packing::markArraySize 0]
    }
}

