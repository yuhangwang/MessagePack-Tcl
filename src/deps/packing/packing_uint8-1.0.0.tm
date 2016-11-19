proc ::MessagePack::packing::uint8 {value} { 
    set value [expr {$value & 0xFF}]
    if {$value < 128} {
        return [::MessagePack::packing::positive_fixnum $value]
    } else {
        return [::MessagePack::packing::fix_uint8 $value]
    }
}

