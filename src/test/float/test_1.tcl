source [file join [pwd] "MessagePack.tcl"]
namespace import MessagePack::*

proc test {} {
    set solution 1.123
    set str [pack float $solution]
    set result [lindex [unpack $str] 0]
    puts "result = $result"
    puts "solution = $solution"
    if {[expr abs($result - $solution) < 1.0e-4]} {
        puts "SUCCESS!"
    } else {
        error "$result != $solution"
    }
}

test