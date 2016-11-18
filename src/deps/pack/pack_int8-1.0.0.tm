proc ::MessagePack::pack::int8 {value} { 
    if {$value < -32} {
        return [::MessagePack::pack::fix_int8 $value]
    } else {
        if {$value < 0} {
        return [::MessagePack::pack::negative_fixnum $value]
        } else {
        if {$value < 128} {
            return [::MessagePack::pack::positive_fixnum $value]
        } else {
            return [::MessagePack::pack::fix_int8 $value]
        }
        }
    }
}
