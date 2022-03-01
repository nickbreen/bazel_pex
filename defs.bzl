
def _pex_binary(ctx):
    repos = depset(transitive = [dep[PyInfo].imports for dep in ctx.attr.deps])
    inputs = depset(transitive = [dep[PyInfo].transitive_sources for dep in ctx.attr.deps])
    outputs = [ctx.outputs.executable]
    tools = [ctx.executable._pex]

    ctx.actions.run_shell(
        #        executable = ctx.executable._pex,
        command = """
        ln -s . $WORKSPACE_NAME  # dirty hack to make the import paths work as they're prefixed with workspace_name
        find -ls
        $PEX "$@"
        """,
        arguments = [
            ctx.actions.args()
                .add("--disable-cache")
                .add("--no-index")
                .add("--output-file", ctx.outputs.executable)
                .add("--entry-point", ctx.attr.main)
                .add_all(repos, before_each = "--repo"),
        ],
        outputs = outputs,
        inputs = inputs,
        tools = tools,
        execution_requirements = {tag: tag for tag in ctx.attr.tags},
        env = dict(PEX_ROOT = ".pex", PEX_IGNORE_RCFILES = "true", PEX_PYTHON = "python3.6", PEX = ctx.executable._pex.path, WORKSPACE_NAME = ctx.workspace_name),
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
