proc ::MessagePack::pack::int {value} { 
    if {$value < -32} {
        return [::MessagePack::pack fix_int8 $value]
    } else {
        if {$value < 0} {
        return [::MessagePack::pack fixnumneg $value]
        } else {
        if {$value < 128} {
            return [::MessagePack::pack fixnumpos $value]
        } else {
            return [::MessagePack::pack fix_int8 $value]
        }
        }
    }
}
