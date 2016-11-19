## Pack a Tcl dictionary into a binary string
# The keys of the dictionary must be a list of the following format
# {{key <key type>} {value <value type>}}
# example dict: {{"Name" string} {"Steven" string}}
# example dict: {{"Name" string} {{1 2 3} {array int}}}
# example dict: {{"Name" string} { { {{1 2} list} {3 int} } list} } }
proc ::MessagePack::packing::dict {input_dict} {
    set result [::MessagePack::packing::markDictSize [::dict size $input_dict]]
    ::dict for {k v} $input_dict {
        lassign $k content_k type_k
        lassign $v content_v type_v
        append result [::MessagePack::packing::aux $type_k $content_k]
        append result [::MessagePack::packing::aux $type_v $content_v]
    }
    append data $result
}

