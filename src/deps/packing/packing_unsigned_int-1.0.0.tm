proc ::MessagePack::packing::unsigned_int {value} { 
    return [::MessagePack::packing::uint32 $value]
}

