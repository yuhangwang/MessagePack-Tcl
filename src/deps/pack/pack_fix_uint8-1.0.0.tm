proc ::MessagePack::pack::fix_uint8 {value} {
    return [binary format cc 0xCC [expr {$value & 0xFF}]]
}
