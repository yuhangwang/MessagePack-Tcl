source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution 1.123
    set binary_string [pack float $solution]
    set showDataType 1
    set result [lindex [unpack $binary_string $showDataType] 0]
    puts "result = {$result}"
    puts "solution = $solution"
    set num [lindex $result 0]
    assertApproxEq $num $solution 1.0e-4
    
    set here [file dirname [file normalize [info script]]]
    set output [file join $here "output" "out2.mp"]
    mpsave $output $binary_string
}

test