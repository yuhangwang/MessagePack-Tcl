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

proc read_files {files accum} {
    if {[llength $files] == 0} {
        return [join $accum "\n"]
    } else {
        read_files [lrange $files 1 end] [concat $accum [list [read_all [lindex $files 0]]]]
    }
}

proc write_file {output content} {
    set OUT [open $output w]
    puts $OUT $content
    close $OUT
}

proc main {output_file} {
    set main_script "MessagePack.tcl"
    set main_str [string map {"source deps/all.tcl" ""} [read_all $main_script]]
    set deps_str [read_files [list_dependencies "deps"] {}]
    write_file $output_file [join [list $main_str $deps_str] "\n"]
}

set version "1.0.0"
main [format "../release/MessagePack-%s.tm" $version]
exit