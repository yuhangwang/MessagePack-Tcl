proc ::MessagePack::pack::uint64 {value} { 
    set value [expr {$value & 0xFFFFFFFFFFFFFFFF}]
    if {$value < 4294967296} {
        return [::MessagePack::pack::int32 $value]
    } else {
        return [::MessagePack::pack::fix_uint64 $value]
    }
}
