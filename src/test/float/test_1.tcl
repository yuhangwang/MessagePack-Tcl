source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution 1.123
    set binary_string [pack float $solution]
    set result [lindex [unpack $binary_string] 0]
    puts "result = $result"
    puts "solution = $solution"
    assertApproxEq $result $solution 1.0e-4

    set here [file dirname [file normalize [info script]]]
    set output [file join $here "output" "out1.mp"]
    mpsave $output $binary_string
}

test