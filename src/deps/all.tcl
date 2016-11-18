::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "tk"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "pack"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "unpack"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "io"]
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
package require pack_dict

package require isStringLongEnough
package require getByte
package require assertApproxEq

package require unpack_operations
package require unpack_aux
package require unpack_positive_fixnum
package require unpack_negative_fixnum
package require unpack_fixdict
package require unpack_fixarray
package require unpack_fixraw
package require unpack_nil
package require unpack_false
package require unpack_true
package require unpack_float
package require unpack_double
package require unpack_dict16
package require unpack_dict32
package require unpack_wrapResult
package require unpack

package require mpread
package require mpsave