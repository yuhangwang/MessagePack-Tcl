## Auxiliary function for packing object
proc ::MessagePack::pack::aux {types obj} {
    if {[llength $types] == 1} {
        set fn $types
        return [::MessagePack::pack::$fn $obj]
    } elseif {[llength $types] == 1} {
        lassgin $types fn subtype
        return [::MessagePack::pack::$fn $subtype $obj]
    } else {
        puts "ERROR HINT: cannot parse types \"$types\" (MessagePack::pack::aux)"
        return ""
    }
}
