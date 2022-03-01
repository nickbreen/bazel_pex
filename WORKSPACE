load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

maybe(
    http_file,
    name = "pex",
    downloaded_file_path = "pex",
    executable = True,
    sha256 = "3f376dba013a6f1a810bfb59fd56a7d95a5ad297f04f57011d0b96cb1624676f",
    urls = ["https://github.com/pantsbuild/pex/releases/download/v2.1.67/pex"],
)
