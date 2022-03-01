
def _pex_binary(ctx):
    repos = depset(transitive = [dep[PyInfo].imports for dep in ctx.attr.deps])
    inputs = depset(transitive = [dep[PyInfo].transitive_sources for dep in ctx.attr.deps])
    print(repos)
    print(inputs)

    # imports are prefixed with the workspace_name :shrug:
    # so that we can avoid having to faff around with the depset(s) just add a symlink for them
    workspace_name_symlink = ctx.actions.declare_symlink(ctx.workspace_name)
    ctx.actions.symlink(output = workspace_name_symlink, target_path = ".")

    # This fails (regardless of the symlink hack above)
    ctx.actions.run(
        executable = ctx.executable._pex,
        arguments = [
            ctx.actions.args()
                .add("--disable-cache")
                .add("--no-index")
                .add("--output-file", ctx.outputs.executable)
                .add("--entry-point", ctx.attr.main)
                .add_all(repos, before_each = "--repo")
                .add_all(repos),
        ],
        outputs = [ctx.outputs.executable],
        inputs = inputs,
        execution_requirements = {tag: tag for tag in ctx.attr.tags},
        env = dict(PEX_ROOT = ".pex", PEX_PYTHON = "python3.6"),
    )

pex_binary = rule(
    implementation = _pex_binary,
    executable = True,
    attrs = {
        "main": attr.string(mandatory = True),
        "deps": attr.label_list(providers = [PyInfo]),
        "_pex": attr.label(default = "@pex//file", executable = True, cfg = "exec"),
    },
)
