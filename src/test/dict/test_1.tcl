source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution {{Name string} {Steven string}}
    puts $solution
    set binary_string [pack dict $solution]
    set answer [unpack $binary_string]
    puts $answer
}

test