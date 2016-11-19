proc ::MessagePack::packing::list {values} { 
    set result [::MessagePack::packing::markArraySize [llength $values]]
    foreach {item type} $values {
        append result [::MessagePack::packing::aux $type $item]
    }
    append data $result
}

