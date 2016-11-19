# MessagePack-Tcl
* A pure Tcl implementation of the [MessagePack](http://msgpack.org/index.html).  
* Designed in functional reactive programming style  
* Compatible with **Tcl 8.5**.


## Download
The latest version can be downloaded from [here](https://github.com/yuhangwang/MessagePack-Tcl/releases/download/1.0.0/MessagePack-1.0.0.tm).
For all versions, please go to the [release](https://github.com/yuhangwang/MessagePack-Tcl/releases) page.  
A normal user just need the `.tm` file. Please ignore the `zip`/`tar.gz` source code release files.  

## Installation
This package is implemented as a [Tcl module](https://www.tcl.tk/man/tcl/TclCmd/tm.htm).  
To use it, just copy the `MessagePack-1.0.0.tm` file to somewhere on your file system and  
add that location to your Tcl module search path:
```{bash}
cp MessagePack-1.0.0.tm /home/steven/TclModules
```

```{tcl}
::tcl::tm::path add "/home/steven/TclModules"
```


## Example:
```{tcl}
::tcl::tm::path add "/home/steven/TclModules"
package require MessagePack
namespace import ::MessagePack::*

proc try_double {} {
    set data 1.123
    return [pack double $data]
}

proc try_string {} {
    set data "Hello World!"
    return [pack string $data]
}

proc try_c_array {} {
    set data {1.0 2.0 3.0}
    return [pack {c_array float} $data]
}

proc try_dict {} {
    # default data type for dict key is "string"
    # otherwise each entry must contain its data type information
    set data { \
        coordinates { \
            {   \
                Z {{1 2 3 4} {c_array float}} \
            } \
            dict \
        } \
    }
    return [pack dict $data]
}

proc tests {} {
    return {try_double try_string try_c_array try_dict}
}

proc main {} {
    foreach test [tests] {
        set binary_string [$test]
        set data [unpack $binary_string]
        puts $data
    }

    # an example of writing/reading MessagePack data
    mpsave "out.msgpack" [pack {c_array float} {1 2 3 4 5}] ;# save
    set content [mpread "out.msgpack"] ;# read
    puts $content
}

main
```

## License
MIT/X11  
Author: Yuhang(Steven) Wang
Date: 11/19/2016

