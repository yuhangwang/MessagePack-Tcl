## Unpack a MessagePack binary string
proc ::MessagePack::unpack {binary_string} {
    lassign [::MessagePack::unpack_aux $binary_string]] result _
    return [list $result]
}
