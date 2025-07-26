"""tcl_toolchain"""

load(
    "//tcl/private:toolchain.bzl",
    _TOOLCHAIN_TYPE = "TOOLCHAIN_TYPE",
    _tcl_toolchain = "tcl_toolchain",
)

tcl_toolchain = _tcl_toolchain
TOOLCHAIN_TYPE = _TOOLCHAIN_TYPE
