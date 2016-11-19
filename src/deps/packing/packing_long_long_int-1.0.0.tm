proc ::MessagePack::packing::long_long_int {value} { 
    return [::MessagePack::packing::int64 $value]
}

