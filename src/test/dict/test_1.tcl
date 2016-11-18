source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution {{"a" string int} 1}
    set binary_string [pack dict $solution]
    set answer [unpack $binary_string]
}