## Axillary function for unpacking a MessagePack binary string
proc ::MessagePack::unpack_aux {binary_string params} {
    lassign [::MessagePack::getChar $binary_string] char binary_string
    set result "nil"
    foreach op [::MessagePack::unpack::operations] {
        lassign [$op $char $binary_string $params $result] _1 binary_string _2 result
    }
    return [list $result $binary_string]
}
