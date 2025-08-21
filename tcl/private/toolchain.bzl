"""tcl toolchain rules"""

TOOLCHAIN_TYPE = str(Label("//tcl:toolchain_type"))

def _rlocationpath(file, workspace_name):
    if file.short_path.startswith("../"):
        return file.short_path[len("../"):]

    return "{}/{}".format(workspace_name, file.short_path)

def _parse_tclcore(label, workspace_name, target):
    for file in target[DefaultInfo].files.to_list():
        if file.basename == "init.tcl":
            include = _rlocationpath(file, workspace_name)[:-len("/init.tcl")]
            return struct(
                include = include,
                init_tcl = file,
            )

    fail("Failed to parse `tclcore` from `{}` for `{}`".format(target.label, label))

def _parse_tcllib(label, workspace_name, target):
    top_pkg_index = None
    for file in target[DefaultInfo].files.to_list():
        if file.basename == "pkgIndex.tcl":
            if not top_pkg_index:
                top_pkg_index = file
                continue

            if len(top_pkg_index.short_path) > len(file.short_path):
                top_pkg_index = file

    if top_pkg_index:
        include = _rlocationpath(top_pkg_index, workspace_name)[:-len("/pkgIndex.tcl")]
        return struct(
            pkg_index = top_pkg_index,
            include = include,
        )

    fail("Failed to parse `tcllib` from `{}` for `{}`".format(target.label, label))

def _tcl_toolchain_impl(ctx):
    make_variable_info = platform_common.TemplateVariableInfo({
        "TCLSH": ctx.executable.tclsh.short_path,
    })

    all_files = depset(transitive = [
        ctx.attr.tclsh[DefaultInfo].default_runfiles.files,
        ctx.attr.tclsh[DefaultInfo].files,
        ctx.attr.tclcore[DefaultInfo].default_runfiles.files,
        ctx.attr.tclcore[DefaultInfo].files,
        ctx.attr.tcllib[DefaultInfo].default_runfiles.files,
        ctx.attr.tcllib[DefaultInfo].files,
    ])

    tcl_core_info = _parse_tclcore(ctx.label, ctx.workspace_name, ctx.attr.tclcore)
    tcllib_info = _parse_tcllib(ctx.label, ctx.workspace_name, ctx.attr.tcllib)

    return [
        platform_common.ToolchainInfo(
            make_variable_info = make_variable_info,
            tclsh = ctx.executable.tclsh,
            includes = depset([tcllib_info.include, tcl_core_info.include]),
            init_tcl = tcl_core_info.init_tcl,
            tcllib_pkg_index = tcllib_info.pkg_index,
            all_files = all_files,
        ),
        make_variable_info,
    ]

tcl_toolchain = rule(
    doc = "A toolchain for building `Tcl` targets.",
    implementation = _tcl_toolchain_impl,
    attrs = {
        "tclcore": attr.label(
            doc = "A label to the `tclcore` files.",
            mandatory = True,
        ),
        "tcllib": attr.label(
            doc = "A label to the `tcllib` files.",
            mandatory = True,
        ),
        "tclsh": attr.label(
            doc = "The path to a `tclsh` binary.",
            cfg = "exec",
            executable = True,
            mandatory = True,
        ),
    },
)
