proc ::MessagePack::unpacking::dict {char binary_string params previous_result} {
    
 elseif {$tc == 0xDF} {
                    # map 32
                    my $need_proc 4
                    binary scan $data I n
                    set n [expr {$n & 0xFFFFFFFF}]
                    set data [string range $data 4 end]
                    set a {}
                    for {set i 0} {$i < $n} {incr i} {
                        lappend a {*}[my unpack_coro 1 $coro]
                        lappend a {*}[my unpack_coro 1 $coro]
                    }
                    lappend l [list map $a]
                }

    if {$char == 0xDF} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            # find out length of the dict (32-bit or 4 bytes int)
            binary scan $binary_string "I" tmp_n
            set n [expr {$tmp_n & 0xFFFFFFFF}]
            set binary_string [string range $binary_string 4 end]
            set tmp_result {}
            for {set i 0} {$i < $n} {incr i} {
                # loop through each key-value pair
                foreach _ {1 2} {
                    lassign [::MessagePack::unpack_aux $binary_string $params] tmp_value binary_string
                    lappend tmp_result $tmp_value
                }
            }
            set result [::MessagePack::unpacking::wrapResult $tmp_result "double" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
