proc ::MessagePack::pack::int16 {value} {
    if {$value < -128} {
        return [::MessagePack::pack::fix_int16 $value]
    } elseif {$value < 128} {
        return [::MessagePack::pack::int8 $value]
    } elseif {$value < 256} {
        return [::MessagePack::pack::fix_uint8 $value]
    } else {
        return [::MessagePack::pack::fix_uint16 $value]
    }
}
