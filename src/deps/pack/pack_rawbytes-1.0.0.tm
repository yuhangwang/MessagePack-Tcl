proc ::MessagePack::pack::rawbytes {value} {
    return [binary format a* $value]
}