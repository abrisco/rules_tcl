# rules_tcl

## Overview

This repository implements Bazel rules for the [Tcl scripting language](https://www.tcl-lang.org/).

## Setup

To begin using the rules. Add the following to your `MODULE.bazel` file.

```python
bazel_dep(name = "rules_tcl", version = "{version}")

register_toolchains(
    "@rules_tcl//tcl/toolchain",
)
```
