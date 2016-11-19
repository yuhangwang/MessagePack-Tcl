proc ::MessagePack::packing::uint16 {value} { 
    set value [expr {$value & 0xFFFF}]
    if {$value < 256} {
        return [::MessagePack::packing::uint8 $value]
    } else {
        return [::MessagePack::packing::fix_uint16 $value]
    }
}

