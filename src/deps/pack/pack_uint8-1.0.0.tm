proc ::MessagePack::pack::uint8 {value} { 
    set value [expr {$value & 0xFF}]
    if {$value < 128} {
        return [::MessagePack::pack::positive_fixnum $value]
    } else {
        return [::MessagePack::pack::fix_uint8 $value]
    }
}
