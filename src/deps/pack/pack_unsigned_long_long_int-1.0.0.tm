proc ::MessagePack::pack::unsigned_long_long_int {value} { 
    return [::MessagePack::pack::uint64 $value]
}
