::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "tk"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "pack"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "unpack"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "io"]
package require pack_aux
package require pack_positive_fixnum
package require pack_negative_fixnum
package require pack_int
package require pack_long_int
package require pack_long_long_int
package require pack_unsigned_int
package require pack_unsigned_short_int
package require pack_unsigned_long_int
package require pack_unsigned_long_long_int
package require pack_int8
package require pack_int16
package require pack_int32
package require pack_uint8
package require pack_uint16
package require pack_uint32
package require pack_uint64
package require pack_fix_int8
package require pack_fix_int16
package require pack_fix_int32
package require pack_fix_int64
package require pack_fix_uint8
package require pack_fix_uint16
package require pack_fix_uint32
package require pack_fix_uint64
package require pack_float
package require pack_double
package require pack_string
package require pack_nil
package require pack_false
package require pack_true
package require pack_markDictSize
package require pack_markArraySize
package require pack_dict
package require pack_list
package require pack_c_array
package require pack_tcl_array
package require pack_raw
package require pack_rawbytes

package require isStringLongEnough
package require getByte
package require assertApproxEq

package require unpack_operations
package require unpack_aux
package require unpack_positive_fixnum
package require unpack_negative_fixnum
package require unpack_fixmap ;# dict
package require unpack_map16  ;# dict
package require unpack_map32  ;# dict
package require unpack_fixarray
package require unpack_fixraw ;# string
package require unpack_nil
package require unpack_false
package require unpack_true
package require unpack_float
package require unpack_double
package require unpack_wrapResult
package require unpack

package require mpread
package require mpsave