## Return a list functions (operations) required for unpacking
proc ::MessagePack::unpack::operations {} {
    return [list \
        ::MessagePack::unpack::float
    ]
}