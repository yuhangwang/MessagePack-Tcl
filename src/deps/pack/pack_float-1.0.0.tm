proc ::MessagePack::pack::float {value} {
    return [binary format "cR" 0xCA $value]
}