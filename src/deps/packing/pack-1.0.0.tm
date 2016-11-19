proc ::MessagePack::pack {args} {
    set types [lrange $args 0 [expr [llength $args] - 2]]
    set obj   [lindex $args end]
    return [::MessagePack::packing::aux $types $obj]
}