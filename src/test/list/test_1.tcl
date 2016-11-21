source [file join [pwd] "MessagePack.tcl"]
namespace import ::MessagePack::*

proc test {} {
    set input {{2 int} {{1 2 3} {c_array int}}}
    set solution {2 {1 2 3}}
    set binary_string [pack list $input]
    set result [unpack $binary_string]
    puts "result = $result"
    puts "solution = $solution"
    ::MessagePack::assertListEq $result $solution

    set here [file dirname [file normalize [info script]]]
    set output [file join $here "output" "out1.mp"]
    mpsave $output $binary_string
}

test