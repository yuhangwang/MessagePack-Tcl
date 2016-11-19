proc ::MessagePack::pack::array {type values} { 
    set result [::MessagePack::pack::markArraySize [llength $values]]
    foreach item $values {
        append result [::MessagePack::pack::aux $type $item]
    }
    append data $result
}
