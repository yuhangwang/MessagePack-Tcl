proc ::MessagePack::pack::long_int {value} { 
    return [::MessagePack::pack::int32 $value]
}
