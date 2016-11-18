proc ::MessagePack::pack::dict {value} {
    set result [::MessagePack::pack map [dict size $value]]
    dict for {k v} $value {
        set type_k [lindex $k 1]
        set type_v [lindex $v 2]
        append result [::MessagePack::pack $type_k $k]
        append result [::MessagePack::pack $type_v $v]
    }
    append data $result
}
