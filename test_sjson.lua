local sjson = require "sjson.safe"

local ffi = require "ffi"
local ffi_str = ffi.string
local C = ffi.C


ffi.cdef[[
typedef unsigned char u_char;
u_char * ngx_snprintf(char *s, size_t n, const char * format, ...);
]]


local buf = ffi.new("char[?]", 22)


local _mt = {
    __serialize = function(t)
        local len = C.ngx_snprintf(buf, 22, "%uL", t.n) - ffi.cast("u_char *", buf)
        return ffi_str(buf, len)
    end
}


local num = setmetatable({ n = 6339710985634865533ULL }, _mt)

local a = {}
a[1] = "one"
a[2] = "two"
a[4] = "three"
a.foo = "bar"
setmetatable(a, sjson.array_mt)

local t = {
    [0] = num,
    [1] = num,
    [2] = num,
    a = "a",
    b = "b",
    x = num,
    y = num,
    t1 = sjson.empty_array,
    t2 = {},
    t3 = a,
    t4 = setmetatable({}, sjson.empty_array_mt),
    t5 = setmetatable({1}, sjson.empty_array_mt),
    t6 = setmetatable({a=1}, sjson.empty_array_mt),
}

print(sjson.encode(t))

local decoder = sjson.new()
decoder.decode_big_numbers_as_strings(true)

print(sjson.decode("9"))
print(sjson.decode("99"))
print(sjson.decode("999"))
print(sjson.decode("9999"))
print(sjson.decode("99999"))
print(sjson.decode("999999"))
print(sjson.decode("9999999"))
print(sjson.decode("99999999"))
print(sjson.decode("999999999"))
print(sjson.decode("9999999999"))
print(sjson.decode("99999999999"))
print(sjson.decode("999999999999"))
print(sjson.decode("9999999999999"))
print(sjson.decode("99999999999999"))
print("----")
print(sjson.decode("100000000000000"))
print(sjson.decode("999999999999999"))

assert(decoder.decode("10000000000000") == 10000000000000)
assert(decoder.decode("99999999999999") == 99999999999999)
assert(decoder.decode("100000000000000") == "100000000000000")
assert(decoder.decode("999999999999999") == "999999999999999")
assert(decoder.decode("9007199254740992") == "9007199254740992" )
