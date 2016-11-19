proc ::MessagePack::packing::int8 {value} { 
    if {$value < -32} {
        return [::MessagePack::packing::fix_int8 $value]
    } else {
        if {$value < 0} {
        return [::MessagePack::packing::negative_fixnum $value]
        } else {
        if {$value < 128} {
            return [::MessagePack::packing::positive_fixnum $value]
        } else {
            return [::MessagePack::packing::fix_int8 $value]
        }
        }
    }
}

