proc ::MessagePack::pack::long_long_int {value} { 
    return [::MessagePack::pack::int64 $value]
}
