proc ::MessagePack::packing::string {value} {
    set n [::string length $value]
    if {$n < 32} {
        return [binary format "ca*" [expr {0xA0 | $n}] $value]
    } elseif {$n < 65536} {
        return [binary format "cSa*" 0xDA $n $value]
    } else {
        return [binary format "cIa*" 0xDB $n $value]
    }
}

