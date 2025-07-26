namespace eval writelib {
    proc write_output {filename content} {
        # Ensure the directory exists
        file mkdir [file dirname $filename]

        # Write to the file
        set fh [open $filename "w"]
        puts $fh $content
        close $fh
    }

    package provide writelib 1.0
}
