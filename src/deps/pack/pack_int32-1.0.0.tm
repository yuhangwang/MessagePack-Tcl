proc ::MessagePack::pack::int32 {value} { 
    if {$value < -32768} {
        return [::MessagePack::pack fix_int32 $value]
    } elseif {$value < 65536} {
        return [::MessagePack::pack int16 $value]
    } else {
        return [::MessagePack::pack fix_uint32 $value]
    }
}
