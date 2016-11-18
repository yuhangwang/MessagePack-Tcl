proc ::MessagePack::pack::uint32 {value} { 
    set value [expr {$value & 0xFFFFFFFF}]
    if {$value < 65536} {
        return [::MessagePack::pack::int16 $value]
    } else {
        return [::MessagePack::pack::fix_uint32 $value]
    }
}
