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
    }
    namespace eval unpacking {
        namespace ensemble create
    }
    namespace export pack
    namespace export unpack
    namespace export mpread mpsave
    namespace export assertApproxEq
}
 
proc ::MessagePack::unpacking::fixarray {char binary_string params previous_result} {
    if {$char >= 0x90 && $char <= 0x9F} {
        set n [expr {$char & 0xF}]
        set tmp_result {}
        for {set i 0} {$i < $n} {incr i} {
            lassign [::MessagePack::unpack_aux $binary_string $params] value binary_string
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
        ::MessagePack::unpacking::float \
        ::MessagePack::unpacking::double \
        ::MessagePack::unpacking::fixraw \
        ::MessagePack::unpacking::fixarray \
        ::MessagePack::unpacking::fixmap\
        ::MessagePack::unpacking::map16 \
        ::MessagePack::unpacking::map32 \
        ::MessagePack::unpacking::positive_fixnum\
        ::MessagePack::unpacking::true \
        ::MessagePack::unpacking::false \
    ]
}

## Axillary function for unpacking a MessagePack binary string
proc ::MessagePack::unpack_aux {binary_string params} {
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
                lassign [::MessagePack::unpack_aux $binary_string $params] value binary_string
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
                    lassign [::MessagePack::unpack_aux $binary_string $params] tmp_value binary_string
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
                    lassign [::MessagePack::unpack_aux $binary_string $params] tmp_value binary_string
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

proc ::MessagePack::pack::int32 {value} { 
    if {$value < -32768} {
        return [::MessagePack::pack::fix_int32 $value]
    } elseif {$value < 65536} {
        return [::MessagePack::pack::int16 $value]
    } else {
        return [::MessagePack::pack::fix_uint32 $value]
    }
}

proc ::MessagePack::pack::float {value} {
    return [binary format "cR" 0xCA $value]
}

proc ::MessagePack::pack::int {value} { 
    return [::MessagePack::pack::int32 $value] 
}

proc ::MessagePack::pack::int64 {value} {
    if {$value < -2147483648} {
        return [::MessagePack::pack::fix_int64 $value]
    } elseif {$value < 4294967296} {
        return [::MessagePack::pack::int32 $value]
    } else {
        return [::MessagePack::pack::fix_uint64 $value]
    }
}

proc ::MessagePack::pack::int8 {value} { 
    if {$value < -32} {
        return [::MessagePack::pack::fix_int8 $value]
    } else {
        if {$value < 0} {
        return [::MessagePack::pack::negative_fixnum $value]
        } else {
        if {$value < 128} {
            return [::MessagePack::pack::positive_fixnum $value]
        } else {
            return [::MessagePack::pack::fix_int8 $value]
        }
        }
    }
}

proc ::MessagePack::pack::int16 {value} {
    if {$value < -128} {
        return [::MessagePack::pack::fix_int16 $value]
    } elseif {$value < 128} {
        return [::MessagePack::pack::int8 $value]
    } elseif {$value < 256} {
        return [::MessagePack::pack::fix_uint8 $value]
    } else {
        return [::MessagePack::pack::fix_uint16 $value]
    }
}

proc ::MessagePack::pack::short {value} { 
   return [::MessagePack::pack::int16 $value]
}

proc ::MessagePack::pack::double {value} {
    return [binary format "cQ" 0xCB $value]
}

## Pack a Tcl dictionary into a binary string
# The keys of the dictionary must be a list of the following format
# {{key <key type>} {value <value type>}}
# example dict: {{"Name" string} {"Steven" string}}
# example dict: {{"Name" string} {{1 2 3} {array int}}}
# example dict: {{"Name" string} { { {{1 2} list} {3 int} } list} } }
proc ::MessagePack::pack::dict {input_dict} {
    set result [::MessagePack::pack::markDictSize [::dict size $input_dict]]
    ::dict for {k v} $input_dict {
        lassign $k content_k type_k
        lassign $v content_v type_v
        append result [::MessagePack::pack::aux $type_k $content_k]
        append result [::MessagePack::pack::aux $type_v $content_v]
    }
    append data $result
}

proc ::MessagePack::pack::string {value} {
    set n [::string length $value]
    if {$n < 32} {
        return [binary format "ca*" [expr {0xA0 | $n}] $value]
    } elseif {$n < 65536} {
        return [binary format "cSa*" 0xDA $n $value]
    } else {
        return [binary format "cIa*" 0xDB $n $value]
    }
}

proc ::MessagePack::pack::positive_fixnum {value} { 
    return [binary format c [expr {$value & 0x7F}]]
}

## return a binary indicator which indicates the size of the dictionary
proc ::MessagePack::pack::markDictSize {dict_size} {
    if {$dict_size < 16} {
        return [binary format "c" [expr {0x80 | $dict_size}]]
    } elseif {$dict_size < 65536} {
        return [binary format "cS" 0xDE $dict_size]
    } else {
        return [binary format "cI" 0xDF $dict_size]
    }
}

proc ::MessagePack::pack::long_long_int {value} { 
    return [::MessagePack::pack::int64 $value]
}

proc ::MessagePack::pack::negative_fixnum {value} { 
    return [binary format c [expr {($value & 0x1F) | 0xE0}]]
}

proc ::MessagePack::pack::unsigned_int {value} { 
    return [::MessagePack::pack::uint32 $value]
}

proc ::MessagePack::pack::long_int {value} { 
    return [::MessagePack::pack::int32 $value]
}

proc ::MessagePack::pack::unsigned_long_int {value} { 
    return [::MessagePack::pack::uint32 $value]
}

proc ::MessagePack::pack::unsigned_short_int {value} { 
    return [::MessagePack::pack::uint16 $value]
}

proc ::MessagePack::pack::unsigned_long_long_int {value} { 
    return [::MessagePack::pack::uint64 $value]
}

proc ::MessagePack::pack::uint32 {value} { 
    set value [expr {$value & 0xFFFFFFFF}]
    if {$value < 65536} {
        return [::MessagePack::pack::int16 $value]
    } else {
        return [::MessagePack::pack::fix_uint32 $value]
    }
}

proc ::MessagePack::pack::uint8 {value} { 
    set value [expr {$value & 0xFF}]
    if {$value < 128} {
        return [::MessagePack::pack::positive_fixnum $value]
    } else {
        return [::MessagePack::pack::fix_uint8 $value]
    }
}

proc ::MessagePack::pack::uint64 {value} { 
    set value [expr {$value & 0xFFFFFFFFFFFFFFFF}]
    if {$value < 4294967296} {
        return [::MessagePack::pack::int32 $value]
    } else {
        return [::MessagePack::pack::fix_uint64 $value]
    }
}

proc ::MessagePack::pack::uint16 {value} { 
    set value [expr {$value & 0xFFFF}]
    if {$value < 256} {
        return [::MessagePack::pack::uint8 $value]
    } else {
        return [::MessagePack::pack::fix_uint16 $value]
    }
}

proc ::MessagePack::pack::fix_int32 {value} {
    return [binary format cI 0xD2 [expr {$value & 0xFFFFFFFF}]]
}

proc ::MessagePack::pack::fix_int8 {value} {
    return [binary format cc 0xD0 [expr {$value & 0xFF}]]
}

proc ::MessagePack::pack::fix_int64 {value} {
    return [binary format cW 0xD3 [expr {$value & 0xFFFFFFFFFFFFFFFF}]]
}

proc ::MessagePack::pack::fix_int16 {value} {
    return [binary format cS 0xD1 [expr {$value & 0xFFFF}]]
}

proc ::MessagePack::pack::fix_uint32 {value} {
    [binary format cI 0xCE [expr {$value & 0xFFFFFFFF}]]
}

proc ::MessagePack::pack::fix_uint8 {value} {
    return [binary format cc 0xCC [expr {$value & 0xFF}]]
}

proc ::MessagePack::pack::fix_uint64 {value} {
    return [binary format cW 0xCF [expr {$value & 0xFFFFFFFFFFFFFFFF}]]
}

proc ::MessagePack::pack::fix_uint16 {value} {
    return [binary format cS 0xCD [expr {$value & 0xFFFF}]]
}

proc ::MessagePack::pack::false {value} {
    return [binary format c 0xC2]
}

proc ::MessagePack::pack::nil {value} {
    return [binary format c 0xC0]
}

proc ::MessagePack::pack::markArraySize {value} { 
    if {$value < 16} {
        return [binary format c [expr {0x90 | $value}]]
    } elseif {$value < 65536} {
        return [binary format cS 0xDC $value]
    } else {
        return [binary format cI 0xDD $value]
    }
}

proc ::MessagePack::pack::true {value} {
    return [binary format c 0xC3]
}

## Convert C-style array into binary string
proc ::MessagePack::pack::c_array {type values} { 
    set result [::MessagePack::pack::markArraySize [llength $values]]
    foreach item $values {
        append result [::MessagePack::pack::aux $type $item]
    }
    append data $result
}

proc ::MessagePack::pack::list {values} { 
    set result [::MessagePack::pack::markArraySize [llength $values]]
    foreach {item type} $values {
        append result [::MessagePack::pack::aux $type $item]
    }
    append data $result
}

proc ::MessagePack::pack::raw {value} {
    if {$value < 32} {
        return [binary format c [expr {0xA0 | $value}]]
    } elseif {$value < 65536} {
        return [binary format cS 0xDA $value]
    } else {
        return [binary format cI 0xDB $value]
    }
}
## Auxiliary function for packing object
proc ::MessagePack::pack::aux {types obj} {
    if {[llength $types] == 1} {
        set fn $types
        return [::MessagePack::pack::$fn $obj]
    } else {
        set fn [lindex $types 0]
        set subtypes [lrange $types 1 end]
        return [::MessagePack::pack::$fn {*}$subtypes $obj]
    }
}

proc ::MessagePack::pack::rawbytes {value} {
    return [binary format a* $value]
}
## Convert Tcl array (hash table) which is equivalent to "dict"
# into a binary string
proc ::MessagePack::pack::tcl_array {key_type value_type value} {
        upvar $value hash_array
        set result [::MessagePack::pack::markDictSize [array size $hash_array]]
        foreach k [lsort -dictionary [array names $hash_array]] {
            append result [::MessagePack::pack::aux $key_type $k]
            append result [::MessagePack::pack::aux $value_type $hash_array($k)]
        }
        return $result
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
