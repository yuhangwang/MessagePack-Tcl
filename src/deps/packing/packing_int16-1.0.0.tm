proc ::MessagePack::packing::int16 {value} {
    if {$value < -128} {
        return [::MessagePack::packing::fix_int16 $value]
    } elseif {$value < 128} {
        return [::MessagePack::packing::int8 $value]
    } elseif {$value < 256} {
        return [::MessagePack::packing::fix_uint8 $value]
    } else {
        return [::MessagePack::packing::fix_uint16 $value]
    }
}

