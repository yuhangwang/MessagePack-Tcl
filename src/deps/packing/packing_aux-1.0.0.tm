## Auxiliary function for packing object
proc ::MessagePack::packing::aux {types obj} {
    if {[llength $types] == 0} {
        # default data type is "string"
        return [::MessagePack::packing::string $obj]
    } elseif {[llength $types] == 1} {
        set fn $types
        return [::MessagePack::packing::$fn $obj]
    } else {
        set fn [lindex $types 0]
        set subtypes [lrange $types 1 end]
        return [::MessagePack::packing::$fn {*}$subtypes $obj]
    }
}

