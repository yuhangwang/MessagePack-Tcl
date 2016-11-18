proc ::MessagePack::pack::int {value} { 
    return [::MessagePack::pack::int32 $value] 
}
