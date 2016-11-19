proc ::MessagePack::pack {args} {
    if {[llength $args] == 2} {
        lassign $args types obj
        return [::MessagePack::packing::aux $types $obj]
    } else {
        puts stderr "ERROR HINT: MessagePack::pack takes exactly 2 arguments; [llength $args] were given"
        return ""
    }
}