proc ::MessagePack::packing::int {value} { 
    return [::MessagePack::packing::int32 $value] 
}

