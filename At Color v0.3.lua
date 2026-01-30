-- Florian Granzow, 2026
-- version: At Color v0.3       - fixed: "NC" = 0.301 (prev applied 0.322)
--                              - implemented: NC (applying 4.NC first, then 0.NC. Not all fixtures have 0.NC preset)

-- how to use plugin:
-- allowed input: lee or rosco color numbers ("0" for "NC", "" for CTC input, "201" for L201, ".200" for "ctc L200", "6500" for color temperature preset, "red" for text input)

-- set up variables:
local inputColor                -- user input
local inputCTC                  -- user input for CTC value
local allNC = '0.301'           -- define "NC" preset in all preset pool
local colorNC = '4."NC"'        -- define "NC" preset in color pool

local function message(msg)
    gma.echo(msg)
    gma.feedback(msg)
end

local function main()
    inputColor = gma.textinput('Enter color (0 = NC, "" = CTC):', '')

    -- 0 == "NC"
    if inputColor == "0" then
        gma.cmd('At Preset ' .. colorNC)
        gma.sleep(0.1)
        gma.cmd('At Preset ' .. allNC)
        message('Applied preset "NC".')
        return
    end

    -- "" == CTC
    if inputColor == "" then
        inputCTC = gma.textinput('Enter CTC value:')

        if inputCTC == "" then
            inputCTC = 0
        end

        gma.cmd('Attribute CTO + CTB At ' .. inputCTC)
        message('Applied CTC of ' .. inputCTC .. '.')

        return
    end

    -- 4 digit numer == color temperature, apply directly
    if tostring(inputColor):match("^%d%d%d%d") then
        gma.cmd('At Preset 4."*' .. inputColor .. '*"')
        message('Applied color temp of ' .. inputColor .. 'K.')
        return
    end

    -- if "." is used to indicate ctc color (eg. ".201" for "ctc L 201")
    if inputColor:find("%.") then
        -- remove "." from string, get everything after it
        inputColor = string.match(inputColor, "%.(.*)$")

        gma.cmd('At Preset 4."ctc R ' .. inputColor .. '*"')
        gma.cmd('At Preset 4."ctc L ' .. inputColor .. '*"')
        message('Applied preset ctc L' .. inputColor .. ' / R' .. inputColor .. '.')

        return
    end

    -- if input is text (e.g. "red")                                                            
    if tonumber(inputColor) == nil then
        gma.cmd('At Preset 4."*' .. inputColor .. '*"')
        message('Applied preset "' .. inputColor .. '".')
        return
    end

    -- fix to solve labeling error in DSOB color pallet
    if inputColor == "161" then
        gma.cmd('At Preset 4."L161*"')
        message('Applied preset "L161".')
        return
    end

    gma.cmd('At Preset 4."R ' .. inputColor .. '*"')    -- warum?? nur für "R023"??!?
    gma.cmd('At Preset 4."*R ' .. inputColor .. '*"')
    gma.cmd('At Preset 4."L ' .. inputColor .. '*"')

    message('Applied preset L' .. inputColor .. ' / R' .. inputColor .. '.')
end

return main