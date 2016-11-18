proc ::MessagePack::pack::true {value} {
    return [binary format c 0xC3]
}
