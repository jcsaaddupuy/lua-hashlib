#include <lua.h>
#include <lauxlib.h>
#include <assert.h>

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#include <openssl/sha.h>
#include <openssl/md5.h>

#define SHA_MT "sha1"
#define SHA256_MT "sha256"
#define MD5_MT "md5"

#define HASHLIB_T(N, T)\
typedef struct {\
    T * ctx; bool init; bool dirty; unsigned char* md;\
} N;

HASHLIB_T(sha1_t, SHA_CTX);
HASHLIB_T(sha256_t, SHA256_CTX);
HASHLIB_T(md5_t, MD5_CTX);
#undef HASHLIB_T



#define HASHLIB_GC(N,T, MT) \
static int luahashtray_gc_##N(lua_State* L) {\
    T * self = luaL_checkudata(L, 1, MT);\
    if (self->init) {\
        free(self->ctx);\
        self->ctx = NULL;\
        free(self->md);\
        self->md = NULL;\
        self->init = false;\
    }\
    return 0;\
}
HASHLIB_GC(sha1, sha1_t, SHA_MT)
HASHLIB_GC(sha256, sha256_t, SHA256_MT)
HASHLIB_GC(md5, md5_t, MD5_MT)
#undef HASHLIB_GC

#define HASHLIB_UPDATE(N, T, MT, M) \
static int luahashtray_update_##N(lua_State* L) {\
    T * self = luaL_checkudata(L, 1, MT);\
    size_t len;\
    const unsigned char * data = (const unsigned char *)luaL_checklstring(L, 2, &len);\
    int ret = M(self->ctx, data, len);\
    self->dirty = true;\
    lua_pushinteger(L, ret);\
	return 1; \
};

HASHLIB_UPDATE(sha1, sha1_t, SHA_MT, SHA1_Update);
HASHLIB_UPDATE(sha256, sha256_t, SHA256_MT, SHA256_Update);
HASHLIB_UPDATE(md5, md5_t, MD5_MT, MD5_Update);
#undef HASHLIB_UPDATE

#define HASHLIB_HEXDIGEST(N, T, MT, S, FINAL)\
static int luahashtray_hexdigest_##N(lua_State* L) {\
    T * self = luaL_checkudata(L, 1, MT);\
    if (self->dirty){\
        FINAL(self->md, self->ctx);\
        self->dirty=false;\
    }\
    luaL_Buffer buffer;\
    luaL_buffinitsize(L, &buffer, S*2);\
    char c[2];\
    int i=0;\
    for (i=0; i < S; i++) {\
        sprintf(c, "%02x", self->md[i]); \
        luaL_addlstring(&buffer, c, 2);\
    }\
    luaL_pushresult(&buffer);\
	return 1;\
};


HASHLIB_HEXDIGEST(sha1, sha1_t, SHA_MT, SHA_DIGEST_LENGTH, SHA1_Final)
HASHLIB_HEXDIGEST(sha256, sha256_t, SHA256_MT, SHA256_DIGEST_LENGTH, SHA256_Final)
HASHLIB_HEXDIGEST(md5, md5_t, MD5_MT, MD5_DIGEST_LENGTH, MD5_Final)

#undef HASHLIB_HEXDIGEST


#define HASHLIB_METHODS(N)\
static luaL_Reg luahashtray_methods_##N[] = {\
    {"__gc", luahashtray_gc_##N },\
    {"update", luahashtray_update_##N },\
    {"hexdigest", luahashtray_hexdigest_##N}, \
    { NULL, NULL }\
}

HASHLIB_METHODS(sha1);
HASHLIB_METHODS(sha256);
HASHLIB_METHODS(md5);
#undef HASHLIB_METHODS

#define HASHLIB_NEW(N, T, MT, CTX, INIT, MDLENGTH, M)\
static int luahashtray_##N(lua_State* L) {\
    T * self = lua_newuserdata(L, sizeof(T));\
    self->ctx = malloc(sizeof(CTX));\
    self->md = malloc(MDLENGTH);\
    INIT(self->ctx);\
    if (luaL_newmetatable(L, MT)) {\
        lua_pushvalue(L, -1);\
        lua_setfield(L, -2, "__index");\
        luaL_setfuncs(L, luahashtray_methods_##N, 0);\
    }\
    lua_setmetatable(L, -2);\
    int n = lua_gettop(L);\
    if(n > 1){\
        size_t len;\
        const unsigned char * data = (const unsigned char *)luaL_checklstring(L, 1, &len);\
        int ret = M(self->ctx, data, len);\
    }\
    self->dirty = true;\
    self->init = true;\
    return 1;\
}
HASHLIB_NEW(sha1, sha1_t, SHA_MT, SHA_CTX, SHA1_Init, SHA_DIGEST_LENGTH, SHA_Update)
HASHLIB_NEW(sha256, sha256_t, SHA256_MT, SHA256_CTX, SHA256_Init, SHA256_DIGEST_LENGTH, SHA256_Update)
HASHLIB_NEW(md5, md5_t, MD5_MT, MD5_CTX, MD5_Init, MD5_DIGEST_LENGTH, MD5_Update)
#undef HASHLIB_NEW

static luaL_Reg hashtray_funcs[] = {
#define X(i)    { #i, luahashtray_##i }
    X(sha1),
    X(sha256),
    X(md5),
#undef X
    { NULL, NULL }
};

int luaopen_hashlib(lua_State* L) {
    luaL_newlib(L, hashtray_funcs);

    lua_pushstring(L, "hashlib-0.0.1");
    lua_setfield(L, -2, "VERSION");

    return 1;
}
