## Save MessagePack binary string to a file
proc ::MessagePack::mpsave {file_name binary_string} {
    set OUT [open $file_name w]
    fconfigure $OUT -translation binary
    puts -nonewline $OUT $binary_string
    close $OUT
    return 1
}