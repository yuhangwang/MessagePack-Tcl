proc ::MessagePack::packing::float {value} {
    return [binary format "cR" 0xCA $value]
}

