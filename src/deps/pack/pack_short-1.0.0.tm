proc ::MessagePack::pack::short {value} { 
   return [::MessagePack::pack int16 $value]
}
