## Module: MessagePack
#  convert Tcl dict into a MessagePack object
# -----------------------------------------------
# Author: Yuhang(Steven) Wang
# Date: 01/17/2016
# License: MIT/X11
# -----------------------------------------------
namespace eval ::MessagePack {
    namespace eval pack {
        namespace export int float
        namespace ensemble create
    }
    namespace eval unpack {
        namespace export all
        namespace ensemble create
    }

    namespace export pack unpack
}
source deps/all.tcl 
