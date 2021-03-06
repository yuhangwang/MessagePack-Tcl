## Module: MessagePack
#  convert Tcl dict into a MessagePack object
# -----------------------------------------------
# Author: Yuhang(Steven) Wang
# Date: 01/17/2016
# License: MIT/X11
# -----------------------------------------------
namespace eval ::MessagePack {
    namespace eval packing {}
    namespace eval unpacking {}
    namespace export pack
    namespace export unpack
    namespace export mpread mpsave
}
 
## consume a byte (8 bits) and return {data result}
# where the $data is the truncated input binary string by one char
# and $result is the result of [expr {$char & 0xFF}]
proc ::MessagePack::getByte {binary_string} {
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
## check whether two lists are equal
proc ::MessagePack::assertListEq {L1 L2} {
    if {[llength $L1] == [llength $L2]} {
        return 0
    } else {
        if {[llength $L1] > 1} {
            set n1 [lindex $L1 0]
            set n2 [lindex $L2 0]
            if {$n1 != $n2} {
                return 0
            } else {
                set tail1 [lrange $L1 2 end]
                set tail2 [lrange $L2 2 end]
                return [::MessagePack::assertListEq $tail1 $tail2 ]
            }
        }
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
    set ooo [::MessagePack::unpack [read $IN]]
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
proc ::MessagePack::packing::int32 {value} { 
    if {$value < -32768} {
        return [::MessagePack::packing::fix_int32 $value]
    } elseif {$value < 65536} {
        return [::MessagePack::packing::int16 $value]
    } else {
        return [::MessagePack::packing::fix_uint32 $value]
    }
}


proc ::MessagePack::packing::float {value} {
    return [binary format "cR" 0xCA $value]
}


proc ::MessagePack::packing::int {value} { 
    return [::MessagePack::packing::int32 $value] 
}


proc ::MessagePack::packing::int64 {value} {
    if {$value < -2147483648} {
        return [::MessagePack::packing::fix_int64 $value]
    } elseif {$value < 4294967296} {
        return [::MessagePack::packing::int32 $value]
    } else {
        return [::MessagePack::packing::fix_uint64 $value]
    }
}


proc ::MessagePack::packing::int8 {value} { 
    if {$value < -32} {
        return [::MessagePack::packing::fix_int8 $value]
    } else {
        if {$value < 0} {
        return [::MessagePack::packing::negative_fixnum $value]
        } else {
        if {$value < 128} {
            return [::MessagePack::packing::positive_fixnum $value]
        } else {
            return [::MessagePack::packing::fix_int8 $value]
        }
        }
    }
}


proc ::MessagePack::packing::int16 {value} {
    if {$value < -128} {
        return [::MessagePack::packing::fix_int16 $value]
    } elseif {$value < 128} {
        return [::MessagePack::packing::int8 $value]
    } elseif {$value < 256} {
        return [::MessagePack::packing::fix_uint8 $value]
    } else {
        return [::MessagePack::packing::fix_uint16 $value]
    }
}


proc ::MessagePack::packing::short {value} { 
   return [::MessagePack::packing::int16 $value]
}


proc ::MessagePack::packing::double {value} {
    return [binary format "cQ" 0xCB $value]
}


## Pack a Tcl dictionary into a binary string
# The keys of the dictionary must be a list of the following format
# {{key <key type>} {value <value type>}}
# example dict: {{"Name" string} {"Steven" string}}
# example dict: {{"Name" string} {{1 2 3} {array int}}}
# example dict: {{"Name" string} { { {{1 2} list} {3 int} } list} } }
proc ::MessagePack::packing::dict {input_dict} {
    set result [::MessagePack::packing::markDictSize [::dict size $input_dict]]
    ::dict for {k v} $input_dict {
        lassign $k content_k type_k
        lassign $v content_v type_v
        append result [::MessagePack::packing::aux $type_k $content_k]
        append result [::MessagePack::packing::aux $type_v $content_v]
    }
    append data $result
}


proc ::MessagePack::packing::string {value} {
    set n [::string length $value]
    if {$n < 32} {
        return [binary format "ca*" [expr {0xA0 | $n}] $value]
    } elseif {$n < 65536} {
        return [binary format "cSa*" 0xDA $n $value]
    } else {
        return [binary format "cIa*" 0xDB $n $value]
    }
}


proc ::MessagePack::packing::positive_fixnum {value} { 
    return [binary format c [expr {$value & 0x7F}]]
}


## return a binary indicator which indicates the size of the dictionary
proc ::MessagePack::packing::markDictSize {dict_size} {
    if {$dict_size < 16} {
        return [binary format "c" [expr {0x80 | $dict_size}]]
    } elseif {$dict_size < 65536} {
        return [binary format "cS" 0xDE $dict_size]
    } else {
        return [binary format "cI" 0xDF $dict_size]
    }
}


proc ::MessagePack::packing::long_long_int {value} { 
    return [::MessagePack::packing::int64 $value]
}


proc ::MessagePack::packing::negative_fixnum {value} { 
    return [binary format c [expr {($value & 0x1F) | 0xE0}]]
}


proc ::MessagePack::packing::unsigned_int {value} { 
    return [::MessagePack::packing::uint32 $value]
}


proc ::MessagePack::packing::long_int {value} { 
    return [::MessagePack::packing::int32 $value]
}


proc ::MessagePack::packing::unsigned_long_int {value} { 
    return [::MessagePack::packing::uint32 $value]
}


proc ::MessagePack::packing::unsigned_short_int {value} { 
    return [::MessagePack::packing::uint16 $value]
}


proc ::MessagePack::packing::unsigned_long_long_int {value} { 
    return [::MessagePack::packing::uint64 $value]
}


proc ::MessagePack::packing::uint32 {value} { 
    set value [expr {$value & 0xFFFFFFFF}]
    if {$value < 65536} {
        return [::MessagePack::packing::int16 $value]
    } else {
        return [::MessagePack::packing::fix_uint32 $value]
    }
}


proc ::MessagePack::packing::uint8 {value} { 
    set value [expr {$value & 0xFF}]
    if {$value < 128} {
        return [::MessagePack::packing::positive_fixnum $value]
    } else {
        return [::MessagePack::packing::fix_uint8 $value]
    }
}


proc ::MessagePack::packing::uint64 {value} { 
    set value [expr {$value & 0xFFFFFFFFFFFFFFFF}]
    if {$value < 4294967296} {
        return [::MessagePack::packing::int32 $value]
    } else {
        return [::MessagePack::packing::fix_uint64 $value]
    }
}


proc ::MessagePack::packing::uint16 {value} { 
    set value [expr {$value & 0xFFFF}]
    if {$value < 256} {
        return [::MessagePack::packing::uint8 $value]
    } else {
        return [::MessagePack::packing::fix_uint16 $value]
    }
}


proc ::MessagePack::packing::fix_int32 {value} {
    return [binary format cI 0xD2 [expr {$value & 0xFFFFFFFF}]]
}


proc ::MessagePack::packing::fix_int8 {value} {
    return [binary format cc 0xD0 [expr {$value & 0xFF}]]
}


proc ::MessagePack::packing::fix_int64 {value} {
    return [binary format cW 0xD3 [expr {$value & 0xFFFFFFFFFFFFFFFF}]]
}


proc ::MessagePack::packing::fix_int16 {value} {
    return [binary format cS 0xD1 [expr {$value & 0xFFFF}]]
}


proc ::MessagePack::packing::fix_uint32 {value} {
    [binary format cI 0xCE [expr {$value & 0xFFFFFFFF}]]
}


proc ::MessagePack::packing::fix_uint8 {value} {
    return [binary format cc 0xCC [expr {$value & 0xFF}]]
}


proc ::MessagePack::packing::fix_uint64 {value} {
    return [binary format cW 0xCF [expr {$value & 0xFFFFFFFFFFFFFFFF}]]
}


proc ::MessagePack::packing::fix_uint16 {value} {
    return [binary format cS 0xCD [expr {$value & 0xFFFF}]]
}


proc ::MessagePack::packing::false {value} {
    return [binary format c 0xC2]
}


proc ::MessagePack::packing::nil {value} {
    return [binary format c 0xC0]
}


proc ::MessagePack::packing::markArraySize {value} { 
    if {$value < 16} {
        return [binary format c [expr {0x90 | $value}]]
    } elseif {$value < 65536} {
        return [binary format cS 0xDC $value]
    } elseif {$value < 4294967296} {
        return [binary format cI 0xDD $value]
    } else {
        puts stderr "ERROR HINT: array size is bigger than what a 32-bit uint can store"
        return [::MessagePack::packing::markArraySize 0]
    }
}


proc ::MessagePack::packing::true {value} {
    return [binary format c 0xC3]
}


## Convert C-style array into binary string
proc ::MessagePack::packing::c_array {type values} { 
    set result [::MessagePack::packing::markArraySize [llength $values]]
    foreach item $values {
        append result [::MessagePack::packing::aux $type $item]
    }
    append data $result
}


proc ::MessagePack::packing::list {values} { 
    set result [::MessagePack::packing::markArraySize [llength $values]]
    foreach pair $values {
        lassign $pair item type
        puts "$item"
        puts "$type"
        append result [::MessagePack::packing::aux $type $item]
    }
    append data $result
}


proc ::MessagePack::packing::raw {value} {
    if {$value < 32} {
        return [binary format c [expr {0xA0 | $value}]]
    } elseif {$value < 65536} {
        return [binary format cS 0xDA $value]
    } else {
        return [binary format cI 0xDB $value]
    }
}

## Auxiliary function for packing object
proc ::MessagePack::packing::aux {types obj} {
    if {[llength $types] == 0} {
        # default data type is "string"
        return [::MessagePack::packing::string $obj]
    } elseif {[llength $types] == 1} {
        set fn $types
        return [::MessagePack::packing::$fn $obj]
    } else {
        set fn [lindex $types 0]
        set subtypes [lrange $types 1 end]
        return [::MessagePack::packing::$fn {*}$subtypes $obj]
    }
}


proc ::MessagePack::packing::rawbytes {value} {
    return [binary format a* $value]
}

## Convert Tcl array (hash table) which is equivalent to "dict"
# into a binary string
proc ::MessagePack::packing::tcl_array {key_type value_type value} {
        upvar $value hash_array
        set result [::MessagePack::packing::markDictSize [array size $hash_array]]
        foreach k [lsort -dictionary [array names $hash_array]] {
            append result [::MessagePack::packing::aux $key_type $k]
            append result [::MessagePack::packing::aux $value_type $hash_array($k)]
        }
        return $result
}


proc ::MessagePack::pack {args} {
    if {[llength $args] == 2} {
        lassign $args types obj
        return [::MessagePack::packing::aux $types $obj]
    } else {
        puts stderr "ERROR HINT: MessagePack::pack takes exactly 2 arguments; [llength $args] were given"
        return ""
    }
}
proc ::MessagePack::unpacking::fixarray {char binary_string params previous_result} {
    if {$char >= 0x90 && $char <= 0x9F} {
        set n [expr {$char & 0xF}]
        set tmp_result {}
        for {set i 0} {$i < $n} {incr i} {
            lassign [::MessagePack::unpacking::aux $binary_string $params] value binary_string
            lappend tmp_result $value
        }
        set result $tmp_result
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::positive_fixnum {char binary_string params previous_result} {
    if {$char < 0x80} {
        set tmp_result [expr {$char & 0x7F}]
        set result [::MessagePack::unpacking::wrapResult $tmp_result "positive_fixnum" $params]
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

## Return a list functions (operations) required for unpacking
proc ::MessagePack::unpacking::operations {} {
    return [list \
        ::MessagePack::unpacking::nil \
        ::MessagePack::unpacking::uint8 \
        ::MessagePack::unpacking::uint16 \
        ::MessagePack::unpacking::uint32 \
        ::MessagePack::unpacking::uint64 \
        ::MessagePack::unpacking::int8 \
        ::MessagePack::unpacking::int16 \
        ::MessagePack::unpacking::int32 \
        ::MessagePack::unpacking::int64 \
        ::MessagePack::unpacking::array16 \
        ::MessagePack::unpacking::array32 \
        ::MessagePack::unpacking::float \
        ::MessagePack::unpacking::double \
        ::MessagePack::unpacking::fixraw \
        ::MessagePack::unpacking::fixarray \
        ::MessagePack::unpacking::fixmap\
        ::MessagePack::unpacking::map16 \
        ::MessagePack::unpacking::map32 \
        ::MessagePack::unpacking::positive_fixnum\
        ::MessagePack::unpacking::negative_fixnum\
        ::MessagePack::unpacking::true \
        ::MessagePack::unpacking::false \
        ::MessagePack::unpacking::raw16 \
        ::MessagePack::unpacking::raw32 \
    ]
}

## Axillary function for unpacking a MessagePack binary string
proc ::MessagePack::unpacking::aux {binary_string params} {
    lassign [::MessagePack::getByte $binary_string] char binary_string
    set result [binary format c 0xC0]
    foreach op [::MessagePack::unpacking::operations] {
        lassign [$op $char $binary_string $params $result] _1 binary_string _2 result
    }
    return [list $result $binary_string]
}

proc ::MessagePack::unpacking::negative_fixnum {char binary_string params previous_result} {
    if {($char & 0xE0) >= 0xE0} {
        binary scan [binary format "c" [expr {($char & 0x1F) | 0xE0}]] "c" tmp_result
        set result [::MessagePack::unpacking::wrapResult $tmp_result "negative_fixnum" $params]
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::fixraw {char binary_string params previous_result} {
    if {$char >= 0xA0 && $char <= 0xBF} {
        set n [expr {$char & 0x1F}]
        if {[::MessagePack::isStringLongEnough $binary_string $n]} {
            binary scan $binary_string "a$n" tmp_result
            set binary_string [string range $binary_string $n end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "string" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::fixmap {char binary_string params previous_result} {
    if {$char >= 0x80 && $char <= 0x8F} {
        set n [expr {$char & 0xF}]
        set tmp_result {}
        for {set i 0} {$i < $n} {incr i} {
            foreach _ {1 2} {
                lassign [::MessagePack::unpacking::aux $binary_string $params] value binary_string
                lappend tmp_result $value
            }
        }
        set result $tmp_result
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::true {char binary_string params previous_result} {
    if {$char == 0xC3} {
        set tmp_result 1
        set result [::MessagePack::unpacking::wrapResult $tmp_result "bool" $params]
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::nil {char binary_string params previous_result} {
    if {$char == 0xC0} {
        set tmp_result "nil"
        set result [::MessagePack::unpacking::wrapResult $tmp_result "double" $params]
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
        set tmp_result 0
        set result [::MessagePack::unpacking::wrapResult $tmp_result "bool" $params]
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
    lassign [::MessagePack::unpacking::aux $binary_string $params] result _
    return $result
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

proc ::MessagePack::unpacking::map32 {char binary_string params previous_result} {
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
                    lassign [::MessagePack::unpacking::aux $binary_string $params] tmp_value binary_string
                    lappend tmp_result $tmp_value
                }
            }
            set result $tmp_result
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
        return [list $result $data_type]
    } else {
        return $result
    }
}

proc ::MessagePack::unpacking::map16 {char binary_string params previous_result} {
    if {$char == 0xDE} {
        if {[::MessagePack::isStringLongEnough $binary_string 2]} {
            # find out length of the dict (16-bit or 2 bytes int)
            binary scan $binary_string "I" tmp_n
            set n [expr {$tmp_n & 0xFFFF}]
            set binary_string [string range $binary_string 2 end]
            set tmp_result {}
            for {set i 0} {$i < $n} {incr i} {
                # loop through each key-value pair
                foreach _ {1 2} {
                    lassign [::MessagePack::unpacking::aux $binary_string $params] tmp_value binary_string
                    lappend tmp_result $tmp_value
                }
            }
            set result $tmp_result
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::uint16 {char binary_string params previous_result} {
    if {$char == 0xCD} {
        if {[::MessagePack::isStringLongEnough $binary_string 2]} {
            binary scan $binary_string "S" tmp_value
            set tmp_result [expr {$tmp_value & 0xFFFF}]
            set binary_string [string range $binary_string 2 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "uint16" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::uint8 {char binary_string params previous_result} {
    if {$char == 0xCC} {
        if {[::MessagePack::isStringLongEnough $binary_string 1]} {
            binary scan $binary_string "c" tmp_value
            set tmp_result [expr {$tmp_value & 0xFF}]
            set binary_string [string range $binary_string 1 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "uint8" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::uint32 {char binary_string params previous_result} {
    if {$char == 0xCE} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            binary scan $binary_string "I" tmp_value
            set tmp_result [expr {$tmp_value & 0xFFFFFFFF}]
            set binary_string [string range $binary_string 4 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "uint32" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::int16 {char binary_string params previous_result} {
    if {$char == 0xD1} {
        if {[::MessagePack::isStringLongEnough $binary_string 2]} {
            binary scan $binary_string "S" tmp_result
            set binary_string [string range $binary_string 2 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "int16" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::uint64 {char binary_string params previous_result} {
    if {$char == 0xCF} {
        if {[::MessagePack::isStringLongEnough $binary_string 8]} {
            binary scan $binary_string "W" tmp_value
            set tmp_result [expr {$tmp_value & 0xFFFFFFFFFFFFFFFF}]
            set binary_string [string range $binary_string 8 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "uint64" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::int32 {char binary_string params previous_result} {
    if {$char == 0xD2} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            binary scan $binary_string "I" tmp_result
            set binary_string [string range $binary_string 4 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "int32" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::int8 {char binary_string params previous_result} {
    if {$char == 0xD0} {
        if {[::MessagePack::isStringLongEnough $binary_string 1]} {
            binary scan $binary_string "c" tmp_result
            set binary_string [string range $binary_string 1 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "int8" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::raw32 {char binary_string params previous_result} {
    if {$char == 0xDB} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            binary scan $binary_string "I" tmp_n
            set n [expr {$tmp_n & 0xFFFFFFFF}]
            set binary_string [string range $binary_string 4 end]

            # scan n bytes
            if {[::MessagePack:isStringLongEnough $binary_string $n]} {
                binary scan $binary_string "a$n" tmp_result
                set binary_string [string range $binary_string $n end]
            } else {
                set tmp_result $previous_result
            }

            set result [::MessagePack::unpacking::wrapResult $tmp_result "string" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::int64 {char binary_string params previous_result} {
    if {$char == 0xD3} {
        if {[::MessagePack::isStringLongEnough $binary_string 8]} {
            binary scan $binary_string "W" tmp_result
            set binary_string [string range $binary_string 8 end]
            set result [::MessagePack::unpacking::wrapResult $tmp_result "int64" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::array16 {char binary_string params previous_result} {
    if {$char == 0xDC} {
        if {[::MessagePack::isStringLongEnough $binary_string 2]} {
            binary scan $binary_string "S" tmp_n
            set n [expr {$tmp_n & 0xFFFF}]
            set binary_string [string range $binary_string 2 end]

            set tmp_result {}
            for {set i 0} {$i < $n} {incr i} {
                lassign [::MessagePack::unpacking::aux $binary_string $params] tmp_value binary_string
                lappend tmp_result $tmp_value
            }
            set result $tmp_result
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::raw16 {char binary_string params previous_result} {
    if {$char == 0xDA} {
        if {[::MessagePack::isStringLongEnough $binary_string 2]} {
            binary scan $binary_string "S" tmp_n
            set n [expr {$tmp_n & 0xFFFF}]
            set binary_string [string range $binary_string 2 end]
            
            # scan n bytes
            if {[::MessagePack:isStringLongEnough $binary_string $n]} {
                binary scan $binary_string "a$n" tmp_result
                set binary_string [string range $binary_string $n end]
            } else {
                set tmp_result $previous_result
            }

            set result [::MessagePack::unpacking::wrapResult $tmp_result "string" $params]
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

proc ::MessagePack::unpacking::array32 {char binary_string params previous_result} {
    if {$char == 0xDD} {
        if {[::MessagePack::isStringLongEnough $binary_string 4]} {
            binary scan $binary_string "I" tmp_n
            set n [expr {$tmp_n & 0xFFFFFFFF}]
            set binary_string [string range $binary_string 4 end]

            set tmp_result {}
            for {set i 0} {$i < $n} {incr i} {
                lassign [::MessagePack::unpacking::aux $binary_string $params] tmp_value binary_string
                lappend tmp_result $tmp_value
            }
            set result $tmp_result
        } else {
            set result $previous_result
        }
    } else {
        set result $previous_result
    }
    return [list $char $binary_string $params $result]
}

