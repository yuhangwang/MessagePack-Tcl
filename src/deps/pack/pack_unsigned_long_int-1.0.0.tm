proc ::MessagePack::pack::unsigned_long_int {value} { 
    return [::MessagePack::pack::uint32 $value]
}
