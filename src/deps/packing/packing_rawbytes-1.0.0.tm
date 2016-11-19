proc ::MessagePack::packing::rawbytes {value} {
    return [binary format a* $value]
}
