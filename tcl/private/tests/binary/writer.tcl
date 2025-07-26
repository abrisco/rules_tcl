# A small test script.

# Parse command-line arguments
set output ""
for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]
    if {$arg eq "--output"} {
        incr i
        set output [lindex $argv $i]
    }
}

# Check that --output was provided
if {$output eq ""} {
    puts stderr "Usage: $argv0 --output <file path>"
    exit 1
}

# Create parent directory if needed
file mkdir [file dirname $output]

# Write the output
set fh [open $output "w"]
puts $fh "La-Li-Lu-Le-Lo."
close $fh
