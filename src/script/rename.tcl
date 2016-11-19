proc list_dependencies {deps_dir} {
    set result {}
    foreach path [glob -nocomplain -dir $deps_dir *] {
        if {[file type $path] eq {directory}} {
            lappend result {*}[list_dependencies $path]
        } elseif {[string match "*.tm" $path]} {
            lappend result $path
        } else {
            continue
        }
    }
    return $result
}

proc read_all {file_name} {
    set IN [open $file_name r]
    set ooo [read $IN]
    close $IN
    return $ooo
}

proc write_file {output content} {
    set OUT [open $output w]
    puts $OUT $content
    close $OUT
}

proc regsub_file {output_file input_file pattern replacement} {
    regsub -all $pattern [read_all $input_file] $replacement content
    write_file $output_file $content
}

proc packing {} {
    set files [list_dependencies [file join "deps" "packing"]]
    foreach f $files {
        regsub "pack_" $f "packing_" new_name
        set output_file [file join "copy" $new_name]
        regsub_file $output_file $f "::pack::" "::packing::"
    }
}

proc unpacking {} {
    set files [list_dependencies [file join "deps" "unpacking"]]
    foreach f $files {
        regsub "unpack_" $f "unpacking_" new_name
        set output_file [file join "copy" $new_name]
        file copy -force $f $output_file
    }
}

unpacking