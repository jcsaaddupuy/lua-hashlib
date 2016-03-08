import hashlib
from jinja2 import Template


hmethods = [
    "md5",
    "sha1",
    "sha256",
]

sentences = [
    ("empty string", ""),
    ("sentence 1", "The quick brown fox jumps over the lazy dog"),
    ("sentence 2", "The quick brown fox jumps over the lazy cog"),
    ("null bytes", "\0" * 80),
]

TPL="""
local hashlib = require("hashlib")

{% for method, data  in methods.iteritems() %}
describe("{{method}}", function()
    {% for label, input, expected in data %}
    it("{{label}}", function()
        local digest= hashlib.{{method}}("{{input}}")
        assert.equals("{{expected}}", digest:hexdigest())
    end)

    it("{{label}} - update", function()
        local digest= hashlib.{{method}}()
        digest:update("{{input}}")
        assert.equals("{{expected}}", digest:hexdigest())
    end)
    {%endfor%}
end)
{%endfor%}
"""

CTX={}
for hm in hmethods:
    m = getattr(hashlib, hm)
    if not getattr(CTX, hm, None):
        CTX[hm] = []
    for label, datain in sentences:
        expected = m(datain.encode("utf-8")).hexdigest()
        CTX[hm].append( (label, datain, expected) )

tpl = Template(TPL)
print(tpl.render(methods = CTX))
