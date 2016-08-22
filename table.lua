local exports = {}

function exports.Setup(TableCache)
    TableCache.n = 0
end

function exports.Allocate(TableCache)
    
    local n = TableCache.n
    
    if (n ~= 0) then
        local t = TableCache[n]
        TableCache.n = n - 1
        return t
    end
    return {}
    
end

function exports.Deallocate(TableCache, t)
    local n = TableCache.n + 1
    TableCache[n] = t
    TableCache.n = n
end

return exports