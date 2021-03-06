
local hashlib = require("hashlib")


describe("sha256", function()
    
    it("empty string", function()
        local digest= hashlib.sha256("")
        assert.equals("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", digest:hexdigest())
    end)

    it("empty string - update", function()
        local digest= hashlib.sha256()
        digest:update("")
        assert.equals("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", digest:hexdigest())
    end)
    
    it("sentence 1", function()
        local digest= hashlib.sha256("The quick brown fox jumps over the lazy dog")
        assert.equals("d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592", digest:hexdigest())
    end)

    it("sentence 1 - update", function()
        local digest= hashlib.sha256()
        digest:update("The quick brown fox jumps over the lazy dog")
        assert.equals("d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592", digest:hexdigest())
    end)
    
    it("sentence 2", function()
        local digest= hashlib.sha256("The quick brown fox jumps over the lazy cog")
        assert.equals("e4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be", digest:hexdigest())
    end)

    it("sentence 2 - update", function()
        local digest= hashlib.sha256()
        digest:update("The quick brown fox jumps over the lazy cog")
        assert.equals("e4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be", digest:hexdigest())
    end)
    
    it("null bytes", function()
        local digest= hashlib.sha256("                                                                                ")
        assert.equals("5b6fb58e61fa475939767d68a446f97f1bff02c0e5935a3ea8bb51e6515783d8", digest:hexdigest())
    end)

    it("null bytes - update", function()
        local digest= hashlib.sha256()
        digest:update("                                                                                ")
        assert.equals("5b6fb58e61fa475939767d68a446f97f1bff02c0e5935a3ea8bb51e6515783d8", digest:hexdigest())
    end)
    
end)

describe("sha1", function()
    
    it("empty string", function()
        local digest= hashlib.sha1("")
        assert.equals("da39a3ee5e6b4b0d3255bfef95601890afd80709", digest:hexdigest())
    end)

    it("empty string - update", function()
        local digest= hashlib.sha1()
        digest:update("")
        assert.equals("da39a3ee5e6b4b0d3255bfef95601890afd80709", digest:hexdigest())
    end)
    
    it("sentence 1", function()
        local digest= hashlib.sha1("The quick brown fox jumps over the lazy dog")
        assert.equals("2fd4e1c67a2d28fced849ee1bb76e7391b93eb12", digest:hexdigest())
    end)

    it("sentence 1 - update", function()
        local digest= hashlib.sha1()
        digest:update("The quick brown fox jumps over the lazy dog")
        assert.equals("2fd4e1c67a2d28fced849ee1bb76e7391b93eb12", digest:hexdigest())
    end)
    
    it("sentence 2", function()
        local digest= hashlib.sha1("The quick brown fox jumps over the lazy cog")
        assert.equals("de9f2c7fd25e1b3afad3e85a0bd17d9b100db4b3", digest:hexdigest())
    end)

    it("sentence 2 - update", function()
        local digest= hashlib.sha1()
        digest:update("The quick brown fox jumps over the lazy cog")
        assert.equals("de9f2c7fd25e1b3afad3e85a0bd17d9b100db4b3", digest:hexdigest())
    end)
    
    it("null bytes", function()
        local digest= hashlib.sha1("                                                                                ")
        assert.equals("8fc36a50d0ba5aabfa3cb92d81fe9fdc4686e6a3", digest:hexdigest())
    end)

    it("null bytes - update", function()
        local digest= hashlib.sha1()
        digest:update("                                                                                ")
        assert.equals("8fc36a50d0ba5aabfa3cb92d81fe9fdc4686e6a3", digest:hexdigest())
    end)
    
end)

describe("md5", function()
    
    it("empty string", function()
        local digest= hashlib.md5("")
        assert.equals("d41d8cd98f00b204e9800998ecf8427e", digest:hexdigest())
    end)

    it("empty string - update", function()
        local digest= hashlib.md5()
        digest:update("")
        assert.equals("d41d8cd98f00b204e9800998ecf8427e", digest:hexdigest())
    end)
    
    it("sentence 1", function()
        local digest= hashlib.md5("The quick brown fox jumps over the lazy dog")
        assert.equals("9e107d9d372bb6826bd81d3542a419d6", digest:hexdigest())
    end)

    it("sentence 1 - update", function()
        local digest= hashlib.md5()
        digest:update("The quick brown fox jumps over the lazy dog")
        assert.equals("9e107d9d372bb6826bd81d3542a419d6", digest:hexdigest())
    end)
    
    it("sentence 2", function()
        local digest= hashlib.md5("The quick brown fox jumps over the lazy cog")
        assert.equals("1055d3e698d289f2af8663725127bd4b", digest:hexdigest())
    end)

    it("sentence 2 - update", function()
        local digest= hashlib.md5()
        digest:update("The quick brown fox jumps over the lazy cog")
        assert.equals("1055d3e698d289f2af8663725127bd4b", digest:hexdigest())
    end)
    
    it("null bytes", function()
        local digest= hashlib.md5("                                                                                ")
        assert.equals("bbf7c6077962a7c28114dbd10be947cd", digest:hexdigest())
    end)

    it("null bytes - update", function()
        local digest= hashlib.md5()
        digest:update("                                                                                ")
        assert.equals("bbf7c6077962a7c28114dbd10be947cd", digest:hexdigest())
    end)
    
end)

