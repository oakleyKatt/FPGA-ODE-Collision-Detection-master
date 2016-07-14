set usb [lindex [get_hardware_names] 0]
set device_name [lindex [get_device_names -hardware_name $usb] 0]
puts "*************************"
puts "programming cable:"
puts $usb
set filename "outputs.txt"
set fileId [open $filename "a+"]


set filename "outputs.txt"
# open the filename for writing
set fileId [open $filename "w"]
# C:\altera\14.0\quartus\bin64\quartus_stp -t send55.tcl
#IR scan codes:  001 -> push
#                010 -> pop

proc push {index value} {
global device_name usb

if {$value > 4294967295} {
return "value entered exceeds 32 bits" }

set push_value [int2bits $value]
set diff [expr {32 - [string length $push_value]%32}]

if {$diff != 32} {
set push_value [format %0${diff}d$push_value 0] }

puts $push_value
device_virtual_ir_shift -instance_index $index -ir_value 1 -no_captured_ir_value
device_virtual_dr_shift -instance_index $index -dr_value $push_value -length 32 -no_captured_dr_value
}

proc pop {index} {
	global device_name usb filename fileId
	variable x
	variable y
	
	device_virtual_ir_shift -instance_index $index -ir_value 2 -no_captured_ir_value
	set x [device_virtual_dr_shift -instance_index 0 -length 32]
	puts $x
	puts $fileId $x
	

}

proc popfile {index} {
	global device_name usb filename fileId
	variable x
	variable y
	
	device_virtual_ir_shift -instance_index $index -ir_value 2 -no_captured_ir_value
	set x [device_virtual_dr_shift -instance_index 0 -length 32]
	puts $x
	
	set xy [bin2dec $x]
	#puts $fileId $x

}

proc int2bits {i} {    
set res ""
while {$i>0} {
set res [expr {$i%2}]$res
set i [expr {$i/2}]}
if {$res==""} {set res 0}
return $res
}

proc bin2dec bin {
    #returns integer equivalent of $bin 
    set res 0
    if {$bin == 0} {
        return 0
    } elseif {[string match -* $bin]} {
        set sign -
        set bin [string range $bin[set bin {}] 1 end]
    } else {
        set sign {}
    }
    foreach i [split $bin {}] {
        set res [expr {$res*2+$i}]
    }
    return $sign$res
}

 # proc hex2float {hex} {
 #       global tcl_platform
 #       #if {$tcl_platform(byteOrder) == "littleEndian"} { set hex [reverse4 $hex] }
 #       set sign [expr $hex >> 31]
 #       set exponent [expr ($hex >> 23) & 0xFF]
 #       set mantissa [expr $hex & ((1 << 23) -1)]
 #       set result [expr 1 + 1.0 * $mantissa / (1 << 23)]
 #       set result [expr {($sign ? -1.0 : 1.0)} * $result]
 #       if {$mantissa == 0 && $exponent == 0} {
 #           set result [expr $result * 0.0]
 #       } else {
 #           set result [expr $result * pow(2, $exponent - 127)]
 #       }
 #       return $result
 #   }


proc bin2hex bin {
## No sanity checking is done
array set t {
0000 0 0001 1 0010 2 0011 3 0100 4
0101 5 0110 6 0111 7 1000 8 1001 9
1010 a 1011 b 1100 c 1101 d 1110 e 1111 f
}
set diff [expr {4-[string length $bin]%4}]
if {$diff != 4} {
set bin [format %0${diff}d$bin 0] }
regsub -all .... $bin {$t(&)} hex
return [subst $hex]
}

puts "Read floating point add result"
open_device -device_name $device_name -hardware_name $usb
device_lock -timeout 10000

#sphere
#benchmark 0
#push 0 0x402aba5a
#push 1 0x00000000
#push 2 0x3fc00000
#push 3 0x3f000000
#benchmark 1
#push 0 0x3ef76295
#push 1 0xbe154691
#push 2 0x3ec50c1c
#push 3 0x3d8a771d
#benchmark 2
#push 0 0x3f3f6ed6
#push 1 0xbf0a0ad9
#push 2 0x3e854cdb
#push 3 0x3e85a6a4
#benchmark 3
#push 0 0x3cf1ac15
#push 1 0xbf7c8b65
#push 2 0x3edfd695
#push 3 0x3e7f294e
#benchmark 4
#push 0 0x3f5f8162
#push 1 0xbe3e835e
#push 2 0x3fc130c6
#push 3 0x3f000000
#benchmark 5
#push 0 0x3e797636
#push 1 0xbe6d68c7
#push 2 0x3de5c78a
#push 3 0x3ddf444e
#push 4 0x00000000
#push 4 0x00000001
#pop 5
#pop 6 
#pop 7 
#pop 8
#pop 9
#pop 10
#pop 11
#popfile 12  


#box
#benchmark 0
#push 0 0xbed9101b
#push 1 0x3daecd8e
#push 2 0x3e88678c
#push 3 0x3f0f4b51
#push 4 0x3e73033a
#push 5 0x3ec08377
#push 6 0x3e9b1c22
#push 7 0xbf38eebf
#push 8 0x3f1f2053
#push 9 0x3f6f166e
#push 10 0x3dc30121
#push 11 0xbeb06573
#push 12 0x3e423fab
#push 13 0x3f2f5558
#push 14 0x3f34198f
#benchmark 1
#push 0 0x3e87ba67
#push 1 0x3bdc3bd6
#push 2 0x3ddd4d83
#push 3 0x3e5f444e
#push 4 0x3e75069a
#push 5 0x3f028017
#push 6 0xb9c73abd
#push 7 0x3f569ef5
#push 8 0x3f0b8c76
#push 9 0x396bedfa
#push 10 0xbf0b8c87
#push 11 0x3f569ef5
#push 12 0x3f800000
#push 13 0x39e73605
#push 14 0x3796feb5
#push 15 0x00000000
#push 15 0x00000001
#pop 16 
#pop 17 
#pop 18 
#pop 19 
#pop 20 
#pop 21 
#pop 22 
#popfile 23 
#benchmark 2
#push 0 0xbedab863
#push 1 0x3e67cb71
#push 2 0x4001508f
#push 3 0x3f0f4b51
#push 4 0x3e73033a
#push 5 0x3ec08377
#push 6 0x3e91fba4
#push 7 0xbf367fd4
#push 8 0x3f2404ea
#push 9 0x3f674cc2
#push 10 0x3ed89742
#push 11 0x3d8c84f9
#push 12 0xbea3d039
#push 13 0x3f0f2f77
#push 14 0x3f43c4b1
#push 15 0x00000000
#push 15 0x00000001
#pop 16 
#pop 17 
#pop 18 
#pop 19 
#pop 20 
#pop 21 
#pop 22 
#popfile 23 
#benchmark 3
#push 0 0x3e9e59d1
#push 1 0xbcaed99d
#push 2 0x3e148ba8
#push 3 0x3e5f444e
#push 4 0x3e75069a
#push 5 0x3f028017
#push 6 0x3ea73e25
#push 7 0x3f45843c
#push 8 0x3f0bc0a0
#push 9 0xbe562670
#push 10 0xbf011809
#push 11 0x3f567c8d
#push 12 0x3f6bf5c7
#push 13 0xbec6935c
#push 14 0xbb5c768e
#push 15 0x00000000
#push 15 0x00000001
#pop 16 
#pop 17 
#pop 18 
#pop 19 
#pop 20 
#pop 21 
#pop 22 
#popfile 23 
#benchmark 4
#push 0 0x3e595cc8
#push 1 0x3f33bde0
#push 2 0x3e9c06e2
#push 3 0x3ea6e5cd
#push 4 0x3f0cbfe4
#push 5 0x3de20792
#push 6 0xbd20e304
#push 7 0x3d859ea5
#push 8 0x3f7f41af
#push 9 0x3f7a54a4
#push 10 0x3e54c9c9
#push 11 0x3ccc2b52
#push 12 0xbe528134
#push 13 0x3f79daad
#push 14 0xbd93604a
#push 15 0x00000000
#push 15 0x00000001
#pop 16 
#pop 17 
#pop 18 
#pop 19 
#pop 20 
#pop 21 
#pop 22 
#popfile 23 
#benchmark 5
#push 0 0xbf04e9d5
#push 1 0xbf61b995
#push 2 0x3e4fd695
#push 3 0x3eff296f
#push 4 0x3ef00453
#push 5 0x3ed05708
#push 6 0xbe08a58b
#push 7 0xbf7db5d9
#push 8 0x3a904f6e
#push 9 0xbf7db5d9
#push 10 0x3e08a5ce
#push 11 0x3a15f245
#push 12 0xba3b2bbb
#push 13 0xba8509c0
#push 14 0xbf7fffef
#push 15 0x00000000
#push 15 0x00000001
#pop 16 
#pop 17 
#pop 18 
#pop 19 
#pop 20 
#pop 21 
#pop 22 
#popfile 23 


#capsule
#benchmark 0
#push 0 0xbef45415
#push 1 0x3ea102bc
#push 2 0x400c51fc
#push 3 0x3e92cf10
#push 4 0x3ddfed20
#push 5 0x3f7091f3
#push 6 0x3eaa9803
#push 7 0x3d9d462c
#push 8 0x00000000
#push 8 0x00000001
#pop 9 
#pop 10 
#pop 11 
#pop 12 
#pop 13 
#pop 14 
#pop 15 
#popfile 16 
#benchmark 1
#push 0 0x3d1b4784
#push 1 0xbe11847f
#push 2 0x400f5d14
#push 3 0x3d860e52
#push 4 0x3e6cadde
#push 5 0x3e15d52c
#push 6 0xbd3d4f16
#push 7 0x3f7cf7db
#push 8 0x00000000
#push 8 0x00000001
#pop 9 
#pop 10 
#pop 11 
#pop 12 
#pop 13 
#pop 14 
#pop 15 
#popfile 16 
#benchmark 2
#push 0 0xbf2cdeb1
#push 1 0x3d85f202
#push 2 0x3f603dcd
#push 3 0x3e0f15e8
#push 4 0x3ed61501
#push 5 0xbd8ae4b0
#push 6 0xbf4e9f38
#push 7 0x3f1623c0
#push 8 0x00000000
#push 8 0x00000001
#pop 9 
#pop 10 
#pop 11 
#pop 12 
#pop 13 
#pop 14 
#pop 15 
#popfile 16
#benchmark 3
#push 0 0xbd4ba51a
#push 1 0xbf7cd856
#push 2 0x3e7bdfd2
#push 3 0x3e7f294e
#push 4 0x3ef00453
#push 5 0xbf7ff76a
#push 6 0xbc72cb64
#push 7 0xbbd3f184
#push 8 0x00000000
#push 8 0x00000001
#pop 9 
#pop 10 
#pop 11 
#pop 12 
#pop 13 
#pop 14 
#pop 15 
#popfile 16
#benchmark 4
#push 0 0x3eabfdd6
#push 1 0xbdce05cd
#push 2 0x3de99956
#push 3 0x3ddf444e
#push 4 0x3e75069a
#push 5 0x3f13124d
#push 6 0x3f511e64
#push 7 0x3d53dfb1
#push 8 0x00000000
#push 8 0x00000001
#pop 9 
#pop 10 
#pop 11 
#pop 12 
#pop 13 
#pop 14 
#pop 15 
#popfile 16
#benchmark 5
push 0 0x3e494531
push 1 0xbf28b8d0
push 2 0x4016103d
push 3 0x3d6d3d86
push 4 0x3ed2771d
push 5 0x3f1bcff6
push 6 0x3bcb20fb
push 7 0x3f4b1da3
push 8 0x00000000
push 8 0x00000001
pop 9 
pop 10 
pop 11 
pop 12 
pop 13 
pop 14 
pop 15 
popfile 16


















































close $fileId
device_unlock
close_device