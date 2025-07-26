# A small script for testing user defined library interactions.

package require writelib

# Environment setup
set tmpdir $::env(TEST_TMPDIR)
if {$tmpdir eq ""} {
    puts stderr "TEST_TMPDIR is not set"
    exit 1
}
set outfile [file join $tmpdir output.txt]

# Write the string
set content "La-Li-Lu-Le-Lo"
writelib::write_output $outfile $content

# Read back the file
set fh [open $outfile "r"]
set actual [read $fh]
close $fh

# Strip trailing whitespace
set actual [string trimright $actual]

# Assert the content matches
if {$actual ne $content} {
    puts stderr "ERROR: File contents mismatch!\nExpected: $content\nActual:   $actual"
    exit 1
}

puts "SUCCESS: Test passed. File contents match."
