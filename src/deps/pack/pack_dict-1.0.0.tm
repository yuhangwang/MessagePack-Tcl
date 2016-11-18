## Pack a Tcl dictionary into a binary string
# The keys of the dictionary must be a list of the following format
# {{key <key type>} {value <value type>}}
# example dict: {{"Name" string} {"Steven" string}}
proc ::MessagePack::pack::dict {input_dict} {
    set result [::MessagePack::pack markDictSize [dict size $input_dict]]
    dict for {k v} $input_dict {
        set type_k [lindex $k 1]
        set type_v [lindex $v 2]
        append result [::MessagePack::pack $type_k $k]
        append result [::MessagePack::pack $type_v $v]
    }
    append data $result
}
