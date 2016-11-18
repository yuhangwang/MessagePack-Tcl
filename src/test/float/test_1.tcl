source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set str [pack float 1.0]
    puts [lindex [unpack $str] 0]
}