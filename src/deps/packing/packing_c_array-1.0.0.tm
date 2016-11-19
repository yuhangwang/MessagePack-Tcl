## Convert C-style array into binary string
proc ::MessagePack::packing::c_array {type values} { 
    set result [::MessagePack::packing::markArraySize [llength $values]]
    foreach item $values {
        append result [::MessagePack::packing::aux $type $item]
    }
    append data $result
}

