proc ::MessagePack::pack::fix_int16 {value} {
    return [binary format cS 0xD1 [expr {$value & 0xFFFF}]]
}
