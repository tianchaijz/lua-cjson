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
