## Return a list functions (operations) required for unpacking
proc ::MessagePack::unpacking::operations {} {
    return [list \
        ::MessagePack::unpacking::nil \
        ::MessagePack::unpacking::float \
        ::MessagePack::unpacking::double \
        ::MessagePack::unpacking::fixraw \
        ::MessagePack::unpacking::fixarray \
        ::MessagePack::unpacking::fixmap\
        ::MessagePack::unpacking::map16 \
        ::MessagePack::unpacking::map32 \
        ::MessagePack::unpacking::positive_fixnum\
        ::MessagePack::unpacking::true \
        ::MessagePack::unpacking::false \
    ]
}
