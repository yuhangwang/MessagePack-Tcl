proc ::MessagePack::pack::double {value} {
    return [binary format "cQ" 0xCB $value]
}
