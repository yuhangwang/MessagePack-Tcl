proc ::MessagePack::packing::true {value} {
    return [binary format c 0xC3]
}

