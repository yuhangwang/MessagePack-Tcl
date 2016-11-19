proc ::MessagePack::packing::double {value} {
    return [binary format "cQ" 0xCB $value]
}

