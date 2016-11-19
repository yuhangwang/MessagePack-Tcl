proc ::MessagePack::packing::positive_fixnum {value} { 
    return [binary format c [expr {$value & 0x7F}]]
}

