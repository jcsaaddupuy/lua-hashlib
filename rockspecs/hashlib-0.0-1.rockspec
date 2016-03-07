 package = "hashlib"
 version = "0.0-1"
 source = {
    url = "..."
 }
 description = {
    summary = "An example for the LuaRocks tutorial.",
    detailed = [[
       This is an example for the LuaRocks tutorial.
       Here we would put a detailed, typically
       paragraph-long description.
    ]],
    homepage = "http://...",
    license = "MIT/X11"
 }
 dependencies = {
    "lua ~> 5.3"
 }
 build = {
    -- We'll start here.
    type = "builtin",

    modules= {
        ["hashlib"]={
            sources = "csrc/hashlib.c",
            libraries = {"ssl"},
        },
    },
}
