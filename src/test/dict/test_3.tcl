source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution {{Name string} {Steven string} {id string} {1 int}}
    puts $solution
    set binary_string [pack dict $solution]
    set answer [unpack $binary_string 1]
    puts $answer

    set here [file dirname [file normalize [info script]]]
    set output [file join $here "output" "out3.mp"]
    mpsave $output $binary_string
}

test