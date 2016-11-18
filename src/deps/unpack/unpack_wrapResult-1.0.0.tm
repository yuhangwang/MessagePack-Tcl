## Wrap the result based on parameters
proc ::MessagePack::unpacking::wrapResult {result data_type params} {
    if {[dict get $params showDataType]} {
        return [list $result $data_type]
    } else {
        return $result
    }
}
