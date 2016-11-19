source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution {1 2 3}
    set binary_string [pack c_array float $solution]
    set answer [unpack $binary_string]
    puts $answer

    set here [file dirname [file normalize [info script]]]
    set output [file join $here "output" "out2.mp"]
    mpsave $output $binary_string
}

test