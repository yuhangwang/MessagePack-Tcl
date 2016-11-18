proc ::MessagePack::pack::nil {value} {
    return [binary format c 0xC0]
}
