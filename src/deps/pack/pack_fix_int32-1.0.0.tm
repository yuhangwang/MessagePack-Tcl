proc ::MessagePack::pack::fix_int32 {value} {
    return [binary format cI 0xD2 [expr {$value & 0xFFFFFFFF}]]
}
