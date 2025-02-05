param (
    [string]$drive,
    [string]$iso,
    [int]$mem,
    [int]$cores
)

if (-not $drive -or -not $iso -or -not $mem -or -not $cores) {
    Write-Error "Missing required parameters: 'drive', 'iso', 'mem', 'cores' must be specified"
    exit 1
}

if (-not (Test-Path $drive)) {
    Write-Error "Drive file not found: $drive"
    exit 1
}

if (-not (Test-Path $iso)) {
    Write-Error "ISO file not found: $iso"
    exit 1
}

$qemuArgs = @(
    "-accel whpx",
    "-drive file=`"$drive`",format=qcow2,if=virtio,discard=unmap",
    "-cdrom `"$iso`"",
    "-m ${mem}G",
    "-smp $cores",
    "-netdev user,id=net0,hostfwd=tcp::2222-:22",
    "-device virtio-net,netdev=net0",
    "-vga virtio",
    "-boot order=c",
    "-nographic",
    "-monitor telnet:127.0.0.1:4444,server,nowait"
) -join " "

Write-Host "Starting QEMU with command:"
Write-Host "qemu-system-x86_64 $qemuArgs`n"
qemu-system-x86_64 $qemuArgs.Split(" ")
