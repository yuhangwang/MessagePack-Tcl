## Axillary function for unpacking a MessagePack binary string
proc ::MessagePack::unpack_aux {binary_string params} {
    lassign [::MessagePack::getChar $binary_string] char binary_string
    set result "nil"
    foreach op [::MessagePack::unpacking::operations] {
        puts $char
        puts $binary_string
        puts $params 
        puts $result
        lassign [$op $char $binary_string $params $result] char binary_string _ result
    }
    return [list $result $binary_string]
}
