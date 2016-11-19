proc ::MessagePack::packing::int64 {value} {
    if {$value < -2147483648} {
        return [::MessagePack::packing::fix_int64 $value]
    } elseif {$value < 4294967296} {
        return [::MessagePack::packing::int32 $value]
    } else {
        return [::MessagePack::packing::fix_uint64 $value]
    }
}

