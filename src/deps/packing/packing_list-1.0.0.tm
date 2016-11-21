proc ::MessagePack::packing::list {values} { 
    set result [::MessagePack::packing::markArraySize [llength $values]]
    foreach pair $values {
        lassign $pair item type
        puts "$item"
        puts "$type"
        append result [::MessagePack::packing::aux $type $item]
    }
    append data $result
}

