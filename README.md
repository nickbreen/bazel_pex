Two attempts at building a PEX with Bazel.

1. using a `genrule`
2. using a custom rule

# Problem

The custom rule fails to execute the PEX pex.

# Example

## `genrule`

Works:

    bazel build //:gen/pex
    bazel test //:test/gen/pex

## `pex_binary` (rule)

Fails:

    bazel build //:bin/pex    

>     DEBUG: [...]bazel_pex/BUILD:9:6: {"name": "lib", "visibility": (), "transitive_configs": (), "tags": (), "generator_name": "", "generator_function": "", "generator_location": "", "features": (), "compatible_with": (), "restricted_to": (), "applicable_licenses": (), "deps": (), "data": (), "exec_properties": {}, "exec_compatible_with": (), "target_compatible_with": (), "imports": ("src/main/python",), "srcs_version": "PY2AND3", "srcs": (":src/main/python/breen/__init__.py", ":src/main/python/breen/nick/__init__.py", ":src/main/python/breen/nick/__main__.py", ":src/main/python/setup.py"), "kind": "py_library"}
>     DEBUG: [...]bazel_pex/defs.bzl:5:10: depset(["__main__/src/main/python"])
>     DEBUG: [...]bazel_pex/defs.bzl:6:10: depset([<source file src/main/python/breen/__init__.py>, <source file src/main/python/breen/nick/__init__.py>, <source file src/main/python/breen/nick/__main__.py>, <source file src/main/python/setup.py>])
>     INFO: Analyzed target //:bin/pex (0 packages loaded, 0 targets configured).
>     INFO: Found 1 target...
>     ERROR: [...]bazel_pex/BUILD:27:11: Action bin/pex failed: (Exit 1): pex failed: error executing command
>     (cd [...]/sandbox/linux-sandbox/28/execroot/__main__ && \
>     exec env - \
>     PEX_ROOT=.pex \
>     external/pex/file/pex --disable-cache --no-index --output-file bazel-out/k8-fastbuild/bin/bin/pex --entry-point breen.nick --repo __main__/src/main/python __main__/src/main/python)
>     Execution platform: @local_config_platform//:host
>     
>     Use --sandbox_debug to see verbose messages from the sandbox
>     Traceback (most recent call last):
>     File "/usr/lib64/python3.9/runpy.py", line 197, in _run_module_as_main
>     return _run_code(code, main_globals, None,
>     File "/usr/lib64/python3.9/runpy.py", line 87, in _run_code
>     exec(code, run_globals)
>     File "[...]/sandbox/linux-sandbox/28/execroot/__main__/external/pex/file/pex/__main__.py", line 81, in <module>     
>     File "[...]/sandbox/linux-sandbox/28/execroot/__main__/external/pex/file/pex/__main__.py", line 27, in __maybe_install_pex__
>     File "[...]/sandbox/linux-sandbox/28/execroot/__main__/external/pex/file/pex/__main__.py", line 11, in __re_exec__
>     ValueError: execv() arg 2 first element cannot be empty
>     Target //:bin/pex failed to build

Note paths have been elided with `[...]` to avoid clutter. 