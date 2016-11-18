proc ::MessagePack::pack::unsigned_int {value} { 
    return [::MessagePack::pack::uint32 $value]
}
