::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "tk"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "pack"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "unpack"]
::tcl::tm::path add [file join [file dirname [file normalize [info script]]] "io"]
package require pack_int
package require pack_int16
package require pack_int32
package require pack_float
package require pack_double

package require isStringLongEnough
package require getChar
package require assertApproxEq

package require unpack_operations
package require unpack_aux
package require unpack_positive_fixnum
package require unpack_negative_fixnum
package require unpack_fixmap
package require unpack_fixarray
package require unpack_fixraw
package require unpack_nil
package require unpack_false
package require unpack_true
package require unpack_float
package require unpack_double
package require unpack_wrapResult
package require unpack

package require mpread
package require mpsave