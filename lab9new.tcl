set ns [new Simulator]

set n0 [$ns node]
set n1 [$ns node]

$n0 color "purple"
$n1 color "chocolate"

$ns at 0.0 "$n0 label SYS0"
$ns at 0.0 "$n1 label SYS1"

set nf [open goback.nam w]
$ns namtrace-all $nf

set f [open goback.tr w]
$ns trace-all $f

$ns duplex-link $n0 $n1 1Mb 20ms DropTail
$ns duplex-link-op $n0 $n1 orient right

Agent/TCP set nam_tracevar true
set tcp [new Agent/TCP]
$tcp set fid 1
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.05 "$ftp start"
$ns at 0.06 "$tcp set windowInit 6"
$ns at 0.06 "$tcp set maxcwnd 6"

$ns at 0.25 "$ns queue-limit $n0 $n1 0"
$ns at 0.26 "$ns queue-limit $n0 $n1 10"

$ns at 0.305 "$tcp set windowInit 4"
$ns at 0.305 "$tcp set maxcwnd 4"

$ns at 0.368 "$ns detach-agent $n0 $tcp"
$ns detach-agent $n1 $sink

$ns at 1.5 "finish"

proc finish {} {
    global ns nf f
    $ns flush-trace
    close $nf
    close $f
    exec nam goback.nam &
    exit 0
}

$ns run
