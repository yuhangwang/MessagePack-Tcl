proc ::MessagePack::packing::uint32 {value} { 
    set value [expr {$value & 0xFFFFFFFF}]
    if {$value < 65536} {
        return [::MessagePack::packing::int16 $value]
    } else {
        return [::MessagePack::packing::fix_uint32 $value]
    }
}

