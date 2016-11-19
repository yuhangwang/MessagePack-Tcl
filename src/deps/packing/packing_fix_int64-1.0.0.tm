proc ::MessagePack::packing::fix_int64 {value} {
    return [binary format cW 0xD3 [expr {$value & 0xFFFFFFFFFFFFFFFF}]]
}

