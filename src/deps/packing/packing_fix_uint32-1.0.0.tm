proc ::MessagePack::packing::fix_uint32 {value} {
    [binary format cI 0xCE [expr {$value & 0xFFFFFFFF}]]
}

