load("//:defs.bzl", "pex_binary")

py_library(
    name = "lib",
    srcs = glob(["src/main/python/**/*"]),
    imports = ["src/main/python"],
)

print(existing_rule("lib"))

genrule(
    name = "gen/pex",
    outs = ["gen.pex"],
    cmd = """
    PEX_ROOT=.pex $(execpath @pex//file) --disable-cache --output-file $@ --no-pypi --entry-point breen.nick --repo src/main/python src/main/python
    """,
    srcs = ["lib"],
    tools = ["@pex//file"],
)

sh_test(
    name = "test/gen/pex",
    srcs = ["gen/pex"]
)

pex_binary(
    name = "bin/pex",
    main = "breen.nick",
    deps = ["lib"]
)

sh_test(
    name = "test/bin/pex",
    srcs = ["bin/pex"]
)