--!nonstrict

local sinks = {}
local loading = true

local function parseSinks(stdout)
    local result = {}
    local inSinks = false
    for line in stdout:gmatch("[^\n]+") do
        if line:match("Sinks:") then
            inSinks = true
        elseif line:match("Sources:") or line:match("Filters:") then
            inSinks = false
        end
        if inSinks then
            local id, name = line:match("(%d+)%.%s+(.-)%s*%[vol:")
            if id and name then
                table.insert(result, {
                    id = id,
                    name = name,
                    isDefault = line:find("%*") ~= nil,
                })
            end
        end
    end
    return result
end

local function render()
    if loading then
        panel.render(ui.column({ flexGrow = 1, align = "center", justify = "center" }, {
            ui.label({ text = "Loading...", color = "on_surface_variant" }),
        }))
        return
    end

    if #sinks == 0 then
        panel.render(ui.column({ flexGrow = 1, align = "center", justify = "center" }, {
            ui.label({ text = "No audio outputs found.", color = "on_surface_variant" }),
        }))
        return
    end

    local showClose = noctalia.getSetting("shell.show_close_buttons") ~= false
    local headerItems = {
        ui.label({ text = "Audio Output", fontSize = 16, fontWeight = "bold", color = "on_surface", flexGrow = 1 }),
    }
    if showClose then
        table.insert(headerItems, ui.button({ glyph = "x", onClick = "onCloseClicked" }))
    end

    local sinkButtons = {}
    for _, sink in ipairs(sinks) do
        local s = sink
        local labelColor = s.isDefault and "primary" or "on_surface_variant"
        table.insert(sinkButtons, ui.column({ align = "center", gap = 10 }, {
            ui.button({
                glyph = "volume",
                onClick = function()
                    noctalia.runAsync({ "wpctl", "set-default", s.id }, function()
                        noctalia.runAsync("wpctl status", function(r)
                            if r.exitCode == 0 then
                                sinks = parseSinks(r.stdout)
                            end
                            render()
                        end)
                    end)
                end,
            }),
            ui.label({ text = s.name, color = labelColor, fontSize = 12 }),
        }))
    end

    panel.render(ui.column({ flexGrow = 1, gap = 20 }, {
        ui.row({ align = "center", justify = "space_between", gap = 8 }, headerItems),
        ui.row({ justify = "center", align = "center", gap = 32, flexGrow = 1 }, sinkButtons),
    }))
end

function onOpen(_context)
    loading = true
    render()
    noctalia.runAsync("wpctl status", function(result)
        if result.exitCode == 0 then
            sinks = parseSinks(result.stdout)
        end
        loading = false
        render()
    end)
end

function onCloseClicked()
    panel.close()
end
