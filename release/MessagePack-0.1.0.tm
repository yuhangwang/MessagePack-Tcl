## Module: MessagePack
#  convert Tcl dict into a MessagePack object
# -----------------------------------------------
# Author: Yuhang(Steven) Wang
# Date: 01/17/2016
# License: MIT/X11
# -----------------------------------------------
 
namespace eval ::MessagePack {
    namespace export pack unpack
    variable DATA ""
}

hi
proc hi {} { puts "Hi"}
