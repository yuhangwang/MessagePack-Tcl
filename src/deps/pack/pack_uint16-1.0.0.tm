proc ::MessagePack::pack::uint16 {value} { 
    set value [expr {$value & 0xFFFF}]
    if {$value < 256} {
        return [::MessagePack::pack::uint8 $value]
    } else {
        return [::MessagePack::pack::fix_uint16 $value]
    }
}
