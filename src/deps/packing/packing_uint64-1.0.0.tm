proc ::MessagePack::packing::uint64 {value} { 
    set value [expr {$value & 0xFFFFFFFFFFFFFFFF}]
    if {$value < 4294967296} {
        return [::MessagePack::packing::int32 $value]
    } else {
        return [::MessagePack::packing::fix_uint64 $value]
    }
}

