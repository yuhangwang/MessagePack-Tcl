source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution { \
        coordinates { \
            {   \
                Z {{1 2 3 4} {c_array float}} \
            } \
            dict \
        } \
    }
    puts $solution
    set binary_string [pack dict $solution]
    set answer [unpack $binary_string 0]
    puts $answer

    set here [file dirname [file normalize [info script]]]
    set output [file join $here "output" "out5.mp"]
    mpsave $output $binary_string
}

test