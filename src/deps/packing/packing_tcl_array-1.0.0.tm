## Convert Tcl array (hash table) which is equivalent to "dict"
# into a binary string
proc ::MessagePack::packing::tcl_array {key_type value_type value} {
        upvar $value hash_array
        set result [::MessagePack::packing::markDictSize [array size $hash_array]]
        foreach k [lsort -dictionary [array names $hash_array]] {
            append result [::MessagePack::packing::aux $key_type $k]
            append result [::MessagePack::packing::aux $value_type $hash_array($k)]
        }
        return $result
}

