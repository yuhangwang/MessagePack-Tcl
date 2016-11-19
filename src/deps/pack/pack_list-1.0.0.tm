proc ::MessagePack::pack::list {values} { 
    set result [::MessagePack::pack::markArraySize [llength $values]]
    foreach {item type} $values {
        append result [::MessagePack::pack::aux $type $item]
    }
    append data $result
}
