## Axillary function for unpacking a MessagePack binary string
proc ::MessagePack::unpack_aux {binary_string} {
    lassign [::MessagePack::getChar $binary_string] char binary_string
    set result ""
    foreach op $::MessagePack::unpack::operations {
        lassign [op $char $binary_string $result] char binary_string result
    }
    return [list $result $binary_string]
}
