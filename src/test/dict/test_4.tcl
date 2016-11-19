source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution { \
        {"coordinates" string} { \
            {   \
                {"Z" string} {{1 2 3 4} {c_array float}} \
            } \
            dict} \
    }
    puts $solution
    set binary_string [pack dict $solution]
    set answer [unpack $binary_string 1]
    puts $answer

    set here [file dirname [file normalize [info script]]]
    set output [file join $here "output" "out4.mp"]
    mpsave $output $binary_string
}

test