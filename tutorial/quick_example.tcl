# add the release directory to Tcl module searching path
::tcl::tm::path add [file join [pwd] ".." "release"]
package require MessagePack
namespace import ::MessagePack::*

proc try_double {} {
    set data 1.123
    return [pack double $data]
}

proc try_string {} {
    set data "Hello World!"
    return [pack string $data]
}

proc try_c_array {} {
    set data {1.0 2.0 3.0}
    return [pack {c_array float} $data]
}

proc try_dict {} {
    # default data type for dict key is "string"
    # otherwise each entry must contain its data type information
    set data { \
        coordinates { \
            {   \
                Z {{1 2 3 4} {c_array float}} \
            } \
            dict \
        } \
    }
    return [pack dict $data]
}

proc tests {} {
    return {try_double try_string try_c_array try_dict}
}

proc main {} {
    foreach test [tests] {
        set binary_string [$test]
        set data [unpack $binary_string]
        puts $data
    }

    # an example of writing/reading MessagePack data
    mpsave "out.msgpack" [pack {c_array float} {1 2 3 4 5}]    ;# save
    set content [mpread "out.msgpack"] ;# read
    puts $content
}

main