## check whether two numbers are approximately equal
proc ::MessagePack::assertApproxEq {n1 n2 threshold} {
    if {[expr abs($n1 - $n2) < $threshold]} {
        puts "SUCCESS!"
    } else {
        error "$result != $solution"
    }
}