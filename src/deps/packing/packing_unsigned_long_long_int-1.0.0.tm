proc ::MessagePack::packing::unsigned_long_long_int {value} { 
    return [::MessagePack::packing::uint64 $value]
}

