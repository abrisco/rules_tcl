# A small script for writing text to a file.

puts $auto_path

# Load the writelib package
package require writelib

# Parse CLI arguments
set output ""
for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]
    if {$arg eq "--output"} {
        incr i
        set output [lindex $argv $i]
    }
}

# Validate argument
if {$output eq ""} {
    puts stderr "Usage: $argv0 --output <file path>"
    exit 1
}

# Use the library
writelib::write_output $output "La-Li-Lu-Le-Lo."
