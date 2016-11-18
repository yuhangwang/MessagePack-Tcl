## return a binary indicator which indicates the size of the dictionary
proc ::MessagePack::pack::markDictSize {dict_size} {
    if {$dict_size < 16} {
        return [binary format "c" [expr {0x80 | $dict_size}]]
    } elseif {$dict_size < 65536} {
        return [binary format "cS" 0xDE $dict_size]
    } else {
        return [binary format "cI" 0xDF $dict_size]
    }
}
