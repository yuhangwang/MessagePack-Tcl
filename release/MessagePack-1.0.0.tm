## Module: MessagePack
#  convert Tcl dict into a MessagePack object
# -----------------------------------------------
# Author: Yuhang(Steven) Wang
# Date: 01/17/2016
# License: MIT/X11
# -----------------------------------------------
namespace eval ::MessagePack {
    namespace eval pack {
        namespace export *
        namespace ensemble create
    }
    namespace eval unpacking {
        namespace ensemble create
    }
    namespace export pack unpack
    namespace export mpread mpsave
    namespace export assertApproxEq
}
 

proc ::MessagePack::unpacking::fixarray {char binary_string params previous_result} {
    if {$char >= 0x90 && $char <= 0x9F} {
        set n [expr {$char & 0xF}]
        set accum {}
        for {set i 0} {$i < $n} {incr i} {
            lassign [::MessagePack::unpack_aux $binary_string] tmp_result binary_string
            lappend accum $tmp_result
        }
        
        if {[dict get $params showDataType]} {
            set result [list "fixarray" $accum]
        } else {
            set result $accum
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}
proc ::MessagePack::unpacking::positive_fixnum {char binary_string params previous_result} {
    if {$char < 0x80} {
        set tmp_result [expr {$char & 0x7F}]
        if {[dict get $params showDataType]} {
            set result [list "positive_fixnum" $tmp_result]
        } else {
            set result $tmp_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}
## Return a list functions (operations) required for unpacking
proc ::MessagePack::unpacking::operations {} {
    return [list \
        ::MessagePack::unpacking::nil \
        ::MessagePack::unpacking::float \
        ::MessagePack::unpacking::double \
    ]
}
## Axillary function for unpacking a MessagePack binary string
proc ::MessagePack::unpack_aux {binary_string params} {
    lassign [::MessagePack::getChar $binary_string] char binary_string
    set result "nil"
    foreach op [::MessagePack::unpacking::operations] {
        lassign [$op $char $binary_string $params $result] _1 binary_string _2 result
    }
    return [list $result $binary_string]
}

proc ::MessagePack::unpacking::negative_fixnum {char binary_string params previous_result} {
    if {($char & 0xE0) >= 0xE0} {
        binary scan [binary format "c" [expr {($char & 0x1F) | 0xE0}]] "c" tmp_result

        if {[dict get $params showDataType]} {
            set result [list "negative_fixnum" $tmp_result]
        } else {
            set result $tmp_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}
proc ::MessagePack::unpacking::fixraw {char binary_string params previous_result} {
    if {$char >= 0xA0 && $char <= 0xBF} {
        set n [expr {$char & 0x1F}]
        if {[::MessagePack::isStringLongEnough $binary_string $n]} {
            binary scan $binary_string "a$n" tmp_result
            set binary_string [string range $binary_string $n end]

            if {[dict get $params showDataType]} {
                set result [list "fixraw" $tmp_result]
            } else {
                set result $tmp_result
            }
            
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}

proc ::MessagePack::unpacking::fixmap {char binary_string params previous_result} {
    if {$char >= 0x80 && $char <= 0x8F} {
        set n [expr {$char & 0xF}]
        set accum {}
        for {set i 0} {$i < $n} {incr i} {
            foreach i {1 2} {
                lassign [::MessagePack::unpack_aux $binary_string] tmp_result binary_string
                lappend accum $tmp_result
            }
        }
        if {[dict get $params showDataType]} {
            set result [list "fixmap" $accum]
        } else {
            set result $accum
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $result]
}
proc ::MessagePack::unpacking::true {char binary_string final_result} {
    if {$char == 0xC3} {
        return 1
    } else {
        return [list $char $binary_string $final_result]
    }
}

proc ::MessagePack::unpacking::nil {char binary_string params previous_result} {
    if {$char == 0xC0} {
        if {[dict get $params showDataType]} {
            set result [list "nil" "nil"]
        } else {
            set result "nil"
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::float {char binary_string params previous_result} {
    if {$char == 0xCA} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            binary scan $binary_string "R" tmp_result
            set binary_string [string range $binary_string 4 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "float" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::false {char binary_string params previous_result} {
    if {$char == 0xC2} {
        if {[dict get $params showDataType]} {
            set result {"bool" 0}
        } else {
            set result 0
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

## Unpack a MessagePack binary string
#  optional arguments:
#   showDataType: (default 0) if true, then the data type will be showns
proc ::MessagePack::unpack {binary_string {showDataType 0}} {
    set params [list showDataType $showDataType]
    lassign [::MessagePack::unpack_aux $binary_string $params] result _
    return [list $result]
}

proc ::MessagePack::unpacking::double {char binary_string params previous_result} {
    if {$char == 0xCB} {
        if {[::MessagePack::isStringLongEnough $binary_string 8]} {
            binary scan $binary_string "Q" tmp_result
            set binary_string [string range $binary_string 8 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "double" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

## Wrap the result based on parameters
proc ::MessagePack::unpacking::wrapResult {result data_type params} {
    if {[dict get $params showDataType]} {
        return [list $data_type $result]
    } else {
        return $result
    }
}

proc ::MessagePack::pack::int32 {value} { 
    if {$value < -32768} {
        return [::MessagePack::pack fix_int32 $value]
    } elseif {$value < 65536} {
        return [::MessagePack::pack int16 $value]
    } else {
        return [::MessagePack::pack fix_uint32 $value]
    }
}
proc ::MessagePack::pack::float {value} {
    return [binary format "cR" 0xCA $value]
}
proc ::MessagePack::pack::int {value} { 
    return [::MessagePack::pack int32 $value] 
}
proc ::MessagePack::pack::int64 {value} {
    if {$value < -2147483648} {
        return [::MessagePack::pack fix_int64 $value]
    } elseif {$value < 4294967296} {
        return [::MessagePack::pack int32 $value]
    } else {
        return [::MessagePack::pack fix_uint64 $value]
    }
}
proc ::MessagePack::pack::int {value} { 
    if {$value < -32} {
        return [::MessagePack::pack fix_int8 $value]
    } else {
        if {$value < 0} {
        return [::MessagePack::pack fixnumneg $value]
        } else {
        if {$value < 128} {
            return [::MessagePack::pack fixnumpos $value]
        } else {
            return [::MessagePack::pack fix_int8 $value]
        }
        }
    }
}
proc ::MessagePack::pack::int16 {value} {
    if {$value < -128} {
        return [::MessagePack::pack fix_int16 $value]
    } elseif {$value < 128} {
        return [::MessagePack::pack int8 $value]
    } elseif {$value < 256} {
        return [::MessagePack::pack fix_uint8 $value]
    } else {
        return [::MessagePack::pack fix_uint16 $value]
    }
}
proc ::MessagePack::pack::short {value} { 
   return [::MessagePack::pack int16 $value]
}
proc ::MessagePack::pack::double {value} {
    return [binary format "cQ" 0xCB $value]
}
## consume a char (8-bit integer) and return {data result}
# where the $data is the truncated input binary string by one char
# and $result is the result of [expr {$char & 0xFF}]
proc ::MessagePack::getChar {binary_string} {
    if {[::MessagePack::isStringLongEnough $binary_string, 1]} {
        binary scan $binary_string "c" var
        return [list [expr {$var & 0xFF}] [string range $binary_string 1 end]]
    } else {
        return [list "" $binary_string]
    }
}
## Check whether the string has length at least "n"
proc ::MessagePack::isStringLongEnough {str n} {
    if {[string length $str] < $n} {
        puts "ERROR HINT: input binary string not long enough"
        return 0
    } else {
        return 1
    }
}
## check whether two numbers are approximately equal
proc ::MessagePack::assertApproxEq {n1 n2 threshold} {
    if {[expr abs($n1 - $n2) < $threshold]} {
        puts "SUCCESS!"
    } else {
        error "$result != $solution"
    }
}
## Read MessagePack file
proc ::MessagePack::mpread {file_name} {
    set IN [open $file_name r]
    fconfigure $IN -translation binary
    set ooo [read $IN]
    close $IN
    return $ooo
}
## Save MessagePack binary string to a file
proc ::MessagePack::mpsave {file_name binary_string} {
    set OUT [open $file_name w]
    fconfigure $OUT -translation binary
    puts -nonewline $OUT $binary_string
    close $OUT
    return 1
}
