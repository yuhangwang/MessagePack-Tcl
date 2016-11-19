proc ::MessagePack::packing::long_int {value} { 
    return [::MessagePack::packing::int32 $value]
}

