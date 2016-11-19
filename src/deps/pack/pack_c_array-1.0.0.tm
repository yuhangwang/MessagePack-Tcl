## Convert C-style array into binary string
proc ::MessagePack::pack::c_array {type values} { 
    set result [::MessagePack::pack::markArraySize [llength $values]]
    foreach item $values {
        append result [::MessagePack::pack::aux $type $item]
    }
    append data $result
}
