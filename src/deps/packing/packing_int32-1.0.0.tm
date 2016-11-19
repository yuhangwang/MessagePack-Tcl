proc ::MessagePack::packing::int32 {value} { 
    if {$value < -32768} {
        return [::MessagePack::packing::fix_int32 $value]
    } elseif {$value < 65536} {
        return [::MessagePack::packing::int16 $value]
    } else {
        return [::MessagePack::packing::fix_uint32 $value]
    }
}

