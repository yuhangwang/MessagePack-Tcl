proc ::MessagePack::pack::unsigned_short_int {value} { 
    return [::MessagePack::pack::uint16 $value]
}
