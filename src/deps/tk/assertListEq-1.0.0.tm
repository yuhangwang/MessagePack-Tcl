## check whether two lists are equal
proc ::MessagePack::assertListEq {L1 L2} {
    if {[llength $L1] == [llength $L2]} {
        return 0
    } else {
        if {[llength $L1] > 1} {
            set n1 [lindex $L1 0]
            set n2 [lindex $L2 0]
            if {$n1 != $n2} {
                return 0
            } else {
                set tail1 [lrange $L1 2 end]
                set tail2 [lrange $L2 2 end]
                return [::MessagePack::assertListEq $tail1 $tail2 ]
            }
        }
    }
}
