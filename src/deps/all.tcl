::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "tk"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "packing"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "unpacking"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "io"]
package require packing_aux
package require packing_positive_fixnum
package require packing_negative_fixnum
package require packing_int
package require packing_long_int
package require packing_long_long_int
package require packing_unsigned_int
package require packing_unsigned_short_int
package require packing_unsigned_long_int
package require packing_unsigned_long_long_int
package require packing_int8
package require packing_int16
package require packing_int32
package require packing_uint8
package require packing_uint16
package require packing_uint32
package require packing_uint64
package require packing_fix_int8
package require packing_fix_int16
package require packing_fix_int32
package require packing_fix_int64
package require packing_fix_uint8
package require packing_fix_uint16
package require packing_fix_uint32
package require packing_fix_uint64
package require packing_float
package require packing_double
package require packing_string
package require packing_nil
package require packing_false
package require packing_true
package require packing_markDictSize
package require packing_markArraySize
package require packing_dict
package require packing_list
package require packing_c_array
package require packing_tcl_array
package require packing_raw
package require packing_rawbytes
package require pack

package require isStringLongEnough
package require getByte
package require assertApproxEq
package require assertListEq

package require unpacking_operations
package require unpacking_positive_fixnum
package require unpacking_negative_fixnum
package require unpacking_fixmap ;# dict
package require unpacking_map16  ;# dict
package require unpacking_map32  ;# dict
package require unpacking_fixarray
package require unpacking_fixraw ;# string
package require unpacking_nil
package require unpacking_true
package require unpacking_false
package require unpacking_float
package require unpacking_double
package require unpacking_uint8
package require unpacking_uint16
package require unpacking_uint32
package require unpacking_uint64
package require unpacking_int8
package require unpacking_int16
package require unpacking_int32
package require unpacking_int64
package require unpacking_array16
package require unpacking_array32
package require unpacking_raw16
package require unpacking_raw32
package require unpacking_wrapResult
package require unpacking_aux
package require unpack

package require mpread
package require mpsave