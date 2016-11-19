proc ::MessagePack::packing::false {value} {
    return [binary format c 0xC2]
}

