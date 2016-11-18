proc ::MessagePack::pack::negative_fixnum {value} { 
    return [binary format c [expr {($value & 0x1F) | 0xE0}]]
}
