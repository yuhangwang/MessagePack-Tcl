proc ::MessagePack::packing::fix_uint64 {value} {
    return [binary format cW 0xCF [expr {$value & 0xFFFFFFFFFFFFFFFF}]]
}

