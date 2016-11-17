proc ::MessagePack::pack::int64 {value} {
    if {$value < -2147483648} {
        return [::MessagePack::pack fix_int64 $value]
    } elseif {$value < 4294967296} {
        return [::MessagePack::pack int32 $value]
    } else {
        return [::MessagePack::pack fix_uint64 $value]
    }
}