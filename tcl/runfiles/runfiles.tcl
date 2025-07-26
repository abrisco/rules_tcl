# # Runfiles
#
# Bazel Runfiles Interface for Tcl
#
# This module provides a unified interface to locate Bazel runfiles from
# within a Tcl script.
#
# ## Usage
#
# ```starlark
# tcl_binary(
#     name = "foo",
#     srcs = ["foo.tcl"],
#     data = [
#         "data.txt",
#     ],
#     env = {
#         "DATA_RLOCATIONPATH": "$(rlocationpath data.txt)",
#     },
#     deps = ["//tcl/runfiles"],
# )
# ```
#
# ```tcl
# package require runfiles
# set r [runfiles::create]
# set abs_path [runfiles::rlocation $r "_main/data/file.txt"]
#
# if {[file exists $abs_path]} {
#     puts "Found runfile at $abs_path"
# } else {
#     puts "Runfile not found!"
# }
# ```
#

namespace eval runfiles {
    variable instances 0

    proc create {} {
        # Construct a new runfiles object based on the current environment.
        #
        # Returns:
        #   An object handle representing a runfiles instance.

        if {[info exists ::env(RUNFILES_DIR)]} {
            set runfiles_dir $::env(RUNFILES_DIR)
            return [runfiles::new_directory_based $runfiles_dir]
        }

        if {[info exists ::env(RUNFILES_MANIFEST_FILE)]} {
            set runfiles_manifest $::env(RUNFILES_MANIFEST_FILE)
            return [runfiles::new_directory_based $runfiles_dir]
        }

        error "Unable to construct runfiles."
    }

    proc new_directory_based {runfiles_dir} {
        # Constructor for a directory-based runfiles object.
        #
        # Args:
        #   runfiles_dir: The root of the runfiles directory.
        #
        # Returns:
        #   An object handle.

        if {![file isdirectory $runfiles_dir]} {
            error "Invalid runfiles directory value provided."
        }

        variable instances
        incr instances
        set handle "runfiles_obj_$instances"

        namespace upvar ::runfiles $handle obj
        set obj(runfiles_dir) $runfiles_dir

        return $handle
    }

    proc new_manifest_based {manifest} {
        # Constructor for a manifest-based runfiles object.
        #
        # Args:
        #   manifest: The path to the runfiles manifest.
        #
        # Returns:
        #   An object handle.

        if {![file exists $manifest]} {
            error "Runfiles manifest file does not exist: $manifest"
        }

        # Read manifest into dictionary
        set fh [open $manifest "r"]
        set content [read $fh]
        close $fh

        set map [dict create]
        foreach line [split $content "\n"] {
            if {[string trim $line] eq ""} {
                continue
            }
            foreach {logical_path physical_path} $line {
                dict set map $logical_path $physical_path
            }
        }

        variable instances
        incr instances
        set handle "runfiles_obj_$instances"

        namespace upvar ::runfiles $handle obj
        set obj(manifest_dict) $map

        return $handle
    }

    proc rlocation {handle path} {
        # Returns the absolute path to a runfile given its relative location path.
        #
        # Args:
        #   handle: The runfiles object handle returned by `create`.
        #   path: Relative runfile path.
        #
        # Returns:
        #   Full absolute path as string, or empty string if input path is empty.

        if {[string length $path] == 0} {
            return ""
        }

        namespace upvar ::runfiles $handle obj

        if {[info exists obj(runfiles_dir)]} {
            return [file join $obj(runfiles_dir) $path]
        }

        if {[info exists obj(manifest_dict)]} {
            if {[dict exists $obj(manifest_dict) $path]} {
                return [dict get $obj(manifest_dict) $path]
            } else {
                return ""
            }
        }

        error "Invalid runfiles handle: no known runfiles backend"
    }

    package provide runfiles 1.0
}
