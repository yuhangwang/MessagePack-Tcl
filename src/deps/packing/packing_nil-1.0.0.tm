proc ::MessagePack::packing::nil {value} {
    return [binary format c 0xC0]
}

