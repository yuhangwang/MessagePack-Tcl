source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution 1.123
    set str [pack double $solution]
    set showDataType 1
    set result [lindex [unpack $str $showDataType] 0]
    puts "result = {$result}"
    puts "solution = $solution"
    set num [lindex $result 1]
    if {[expr abs($num - $solution) < 1.0e-4]} {
        puts "SUCCESS!"
    } else {
        error "$result != $solution"
    }

    set here [file dirname [file normalize [info script]]]
    set output [file join $here "output" "out2.mp"]
    mpsave $output $binary_string
}

test