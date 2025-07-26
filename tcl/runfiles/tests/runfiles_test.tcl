# Runfiles library tess

package require runfiles

proc assert_file_content {relpath expected} {
    # Create a runfiles object
    set rf [runfiles::create]

    # Resolve the full path to the runfile
    set fullpath [runfiles::rlocation $rf $relpath]

    if {![file exists $fullpath]} {
        puts stderr "ERROR: File not found: $fullpath"
        exit 1
    }

    set fh [open $fullpath r]
    set content [read $fh]
    close $fh

    set content [string trim $content]

    if {$content ne $expected} {
        puts stderr "ERROR: Mismatch in file content"
        puts stderr "Expected: $expected"
        puts stderr "Actual:   $content"
        exit 1
    }

    puts "SUCCESS: File content matches"
}


assert_file_content $::env(DATA_RLOCATIONPATH) "Hello World."
assert_file_content $::env(GENERATED_DATA_RLOCATIONPATH) "La-Li-Lu-Le-Lo"
