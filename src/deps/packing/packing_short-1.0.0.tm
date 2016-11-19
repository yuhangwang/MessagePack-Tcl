proc ::MessagePack::packing::short {value} { 
   return [::MessagePack::packing::int16 $value]
}

