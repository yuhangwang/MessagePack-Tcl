## Module: MessagePack
#  convert Tcl dict into a MessagePack object
# -----------------------------------------------
# Author: Yuhang(Steven) Wang
# Date: 01/17/2016
# License: MIT/X11
# -----------------------------------------------
namespace eval ::MessagePack {
    namespace eval packing {}
    namespace eval unpacking {}
    namespace export pack
    namespace export unpack
    namespace export mpread mpsave
}
source deps/all.tcl 
