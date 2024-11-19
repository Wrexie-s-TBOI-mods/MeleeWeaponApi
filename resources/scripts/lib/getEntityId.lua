local function getEntityID(entity)
    return tostring(entity.Type) .. "." .. tostring(entity.Variant) .. "." .. tostring(entity.SubType)
end

return getEntityID
