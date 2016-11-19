proc ::MessagePack::packing::fix_int8 {value} {
    return [binary format cc 0xD0 [expr {$value & 0xFF}]]
}

