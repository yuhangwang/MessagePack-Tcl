## Unpack a MessagePack binary string
#  optional arguments:
#   showDataType: (default 0) if true, then the data type will be showns
proc ::MessagePack::unpack {binary_string {showDataType 0}} {
    set params [list showDataType $showDataType]
    lassign [::MessagePack::unpack_aux $binary_string $params]] result _
    return [list $result]
}
