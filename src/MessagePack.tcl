## Module: MessagePack
#  convert Tcl dict into a MessagePack object
# -----------------------------------------------
# Author: Yuhang(Steven) Wang
# Date: 01/17/2016
# License: MIT/X11
# -----------------------------------------------
namespace eval ::MessagePack {
    namespace eval pack {
        namespace export *
    }
    namespace eval unpacking {
        namespace ensemble create
    }
    namespace export pack unpack
    namespace export mpread mpsave
    namespace export assertApproxEq
}
source deps/all.tcl 
