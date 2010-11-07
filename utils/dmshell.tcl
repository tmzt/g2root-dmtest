#!/usr/bin/tclsh8.5
# silly little diagnostic shell thing
# marxmarv 2010-11-07

# requires tclx extensions
# invoke with tclsh8.5 test.tcl

# next line may only be needed due to broken ubuntu
load /usr/lib/libtclx8.4.so

package require Tclx

set devname /tmp/abc

set f [open $devname w+]
fconfigure $f -encoding binary
set offset 0

# Send ESC B C with one byte following
proc send_cmd1 {param1} {
    global f
    puts -nonewline $f [binary format c*c {27 66 67} $param1]
    flush $f
}

# Send ESC B @ with one int16_le param following; read back int32 in LE order
proc send_cmd2 {param1} {
    global f
    puts -nonewline $f [binary format c*s {27 66 64} $param1]
    flush $f
    binary scan [read $f 4] i result
    return result
}

# Send ESC A ^C ^T with two bytes following; read back 4x int32_le, 1x int16_le
proc send_cmd3 {param1 param2} {
    global f
    puts -nonewline $f [binary format c*ccc {27 66 3 20} $param1 $param2]
    flush $f
    binary scan [read $f 18] i4s result result2
    return {$result $result2}
}

proc help {} {
    puts "Commands:"
    puts "send_cmd1 x: sends BC command with uint8 param"
    puts "send_cmd2 x: sends BC command with int16 param and returns int32_le"
    puts "send_cmd3 x y: sends BC command with 2xint8 and returns struct"
}

commandloop
