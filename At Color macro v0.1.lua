-- these two variables have to be set by a different macro command. Because lua code has to be executed with apostrophoe (LUA '')
-- then the variables can be imported into the lua code
local AtPreset = 'At Preset 4."'
local asteriskQuote = '*"'

-- lua code formatted in one line for macro (LUA ''), without ' "" ' scenarios -> strings are set by macros (see above)
-- local AtPreset = gma.user.getvar("AtPreset") local asteriskQuote = gma.user.getvar("asteriskQuote") local inputColor local inputCTC local colorNC = "0.NC" local function message(msg) gma.echo(msg) gma.feedback(msg) end local function main() inputColor = gma.textinput("Enter color (0 = NC,  = CTC):", "") if inputColor == "0" then gma.cmd("At Preset " .. colorNC) message("Applied preset NC.") return end if inputColor == "" then inputCTC = gma.textinput("Enter CTC value:") if inputCTC == "" then inputCTC = 0 end gma.cmd("Attribute CTO + CTB At " .. inputCTC) message("Applied CTC of " .. inputCTC .. ".") return end if tostring(inputColor):match("^%d%d%d%d") then gma.cmd(AtPreset .. "*" .. inputColor .. "*") return end if inputColor:find("%.") then inputColor = string.match(inputColor, "%.(.*)$") gma.cmd(AtPreset .. "ctc L " .. inputColor .. asteriskQuote) gma.cmd(AtPreset .. "ctc R " .. inputColor .. asteriskQuote) return end if inputColor == "161" then gma.cmd(AtPreset .. "L161" .. asteriskQuote) return end gma.cmd(AtPreset .. "L " .. inputColor .. asteriskQuote) gma.cmd(AtPreset .. "*R " .. inputColor .. asteriskQuote) gma.cmd(AtPreset .. "R " .. inputColor .. asteriskQuote) message("Applied preset L" .. inputColor .. " / R" .. inputColor .. ".") end return main

-- lua code begins here
local AtPreset = gma.user.getvar("AtPreset")
local asteriskQuote = gma.user.getvar("asteriskQuote")

local inputColor
local inputCTC
local colorNC = "0.NC"
local function message(msg)
    gma.echo(msg)
    gma.feedback(msg)
end
local function main()
    inputColor = gma.textinput("Enter color (0 = NC,  = CTC):", "")
    if inputColor == "0" then
        gma.cmd("At Preset " .. colorNC)
        message("Applied preset NC.")
        return
    end
    if inputColor == "" then
        inputCTC = gma.textinput("Enter CTC value:")
        if inputCTC == "" then inputCTC = 0 end
        gma.cmd("Attribute CTO + CTB At " .. inputCTC)
        message("Applied CTC of " .. inputCTC .. ".")
        return
    end
    if tostring(inputColor):match("^%d%d%d%d") then
        gma.cmd(AtPreset .. "*" .. inputColor .. "*")
        return
    end
    if inputColor:find("%.") then
        inputColor = string.match(inputColor, "%.(.*)$")
        gma.cmd(AtPreset .. "ctc L " .. inputColor .. asteriskQuote)
        gma.cmd(AtPreset .. "ctc R " .. inputColor .. asteriskQuote)
        return
    end
    if inputColor == "161" then
        gma.cmd(AtPreset .. "L161" .. asteriskQuote)
        return
    end
    gma.cmd(AtPreset .. "L " .. inputColor .. asteriskQuote)
    gma.cmd(AtPreset .. "*R " .. inputColor .. asteriskQuote)
    gma.cmd(AtPreset .. "R " .. inputColor .. asteriskQuote)
    message("Applied preset L" .. inputColor .. " / R" .. inputColor .. ".")
end
return main