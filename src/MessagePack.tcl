## Module: MessagePack
#  convert Tcl dict into a MessagePack object
# -----------------------------------------------
# Author: Yuhang(Steven) Wang
# Date: 01/17/2016
# License: MIT/X11
# -----------------------------------------------
source deps/all.tcl 
namespace eval ::MessagePack {
    namespace eval pack {
        namespace export int
        namespace ensemble create
    }
    namespace export pack unpack
    variable DATA ""
}