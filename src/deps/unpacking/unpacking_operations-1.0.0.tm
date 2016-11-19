## Return a list functions (operations) required for unpacking
proc ::MessagePack::unpacking::operations {} {
    return [list \
        ::MessagePack::unpacking::nil \
        ::MessagePack::unpacking::uint8 \
        ::MessagePack::unpacking::uint16 \
        ::MessagePack::unpacking::uint32 \
        ::MessagePack::unpacking::uint64 \
        ::MessagePack::unpacking::int8 \
        ::MessagePack::unpacking::int16 \
        ::MessagePack::unpacking::int32 \
        ::MessagePack::unpacking::int64 \
        ::MessagePack::unpacking::array16 \
        ::MessagePack::unpacking::array32 \
        ::MessagePack::unpacking::float \
        ::MessagePack::unpacking::double \
        ::MessagePack::unpacking::fixraw \
        ::MessagePack::unpacking::fixarray \
        ::MessagePack::unpacking::fixmap\
        ::MessagePack::unpacking::map16 \
        ::MessagePack::unpacking::map32 \
        ::MessagePack::unpacking::positive_fixnum\
        ::MessagePack::unpacking::negative_fixnum\
        ::MessagePack::unpacking::true \
        ::MessagePack::unpacking::false \
        ::MessagePack::unpacking::raw16 \
        ::MessagePack::unpacking::raw32 \
    ]
}
