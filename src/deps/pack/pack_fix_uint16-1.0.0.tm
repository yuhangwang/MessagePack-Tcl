proc ::MessagePack::pack::fix_uint16 {value} {
    return [binary format cS 0xCD [expr {$value & 0xFFFF}]]
}
