import hashlib
from jinja2 import Template


hmethods = [
    "md5",
    "sha1",
    "sha256",
]

sentences = [
    "",
    "The quick brown fox jumps over the lazy dog",
    "The quick brown fox jumps over the lazy cog",
    "\0" * 80,
]

TPL="""
local hashlib = require("hashlib")

{% for method, input, expected in methods %}
describe("{{method}}", function()
    it("", function()
        local digest= hashlib.{{method}}("{{input}}")
        assert.equals("{{expected}}", digest:hexdigest())
    end)
end)
{%endfor%}
"""

CTX=[]
for hm in hmethods:
    m = getattr(hashlib, hm)
    for _in in sentences:
        expected = m(_in.encode("utf-8")).hexdigest()
        CTX.append( (hm, _in, expected) )

tpl = Template(TPL)
print(tpl.render(methods = CTX))
