## Auxiliary function for packing object
proc ::MessagePack::pack::aux {types obj} {
    if {[llength $types] == 1} {
        set fn $types
        return [::MessagePack::pack::$fn $obj]
    } else {
        set fn [lindex $types 0]
        set subtypes [lrange $types 1 end]
        return [::MessagePack::pack::$fn {*}$subtypes $obj]
    }
}
