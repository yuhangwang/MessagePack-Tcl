## Read MessagePack file
proc ::MessagePack::mpread {file_name} {
    set IN [open $file_name r]
    fconfigure $IN -translation binary
    set ooo [read $IN]
    close $IN
    return $ooo
}