proc ::MessagePack::pack::false {value} {
    return [binary format c 0xC2]
}
