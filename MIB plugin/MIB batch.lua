-- JB, FG, 2026
-- version: MIB v0.1 MIB batch   - fixed: error when no CueZero (added ::continue::)
--                               - implemented: added message() for user feedback, restructured user configuration

-- user configuration:
local mibValue = "Late"         -- Late / Early -> MIB value: see https://help.malighting.com/grandMA2/en/help/key_adv_seq_mib.html
local firstCue = 1              -- set firstCue to ignore pre show cues
local cleanup = true            -- remove unnecessary MIB values

local function message(msg)
    gma.echo(msg)
    gma.feedback(msg)
end

local function main()
    local seqNr = gma.show.getobj.number(gma.user.getselectedexec())
    local seq = gma.show.getobj.handle("Sequence " .. seqNr)
    local numberCues = gma.show.getobj.amount(seq)
    local cuesToAssign = {}
    local cuesToRemove = {}

    gma.cmd("Unblock Cue Thru") -- unblock cues first, to get correct tracking information and MIB options
    gma.sleep(0.1)

    for i=firstCue, numberCues do
        -- guard against nil cue handles
        if gma.show.getobj.child (seq, i) == nil then -- bugfix: fixes error if there is no CueZero; getting cueHandle fails (CueZero always exists, but is not visible to user?)
            goto continue
        end

        local cue = gma.show.getobj.child (seq, i)
        local mibOld = gma.show.property.get(cue,'MIB')
        local cueNr = tonumber(gma.show.getobj.number(cue))

        -- find and remove unnecessary MIB values
        if cleanup and mibOld ~= "" and mibOld ~= "*" and cueNr >= firstCue then
            -- 1. set mib none
            gma.cmd('Assign Cue ' .. cueNr .. ' /MIB=none')
            -- 2. check if MIB still possible and restore old value
            local mibNew = gma.show.property.get(cue,'MIB')
            if mibNew == '*' then
                gma.cmd('Assign Cue '..cueNr..' /MIB=' .. mibOld)
            else
                table.insert(cuesToRemove, cueNr)
            end
        end

        -- if MIB is possible assign value from user config
        if mibOld == '*' and cueNr >= firstCue then
            table.insert(cuesToAssign, cueNr)
        end

        ::continue::
    end

    -- info MIB cleanup
    if #cuesToRemove > 0 then
        message('Removed MIB from Cue(s): ' .. table.concat(cuesToRemove, ', '))
    else
        message('Removed no MIB from Cues.')
    end

    -- batch assign MIB value in a single command
    if #cuesToAssign > 0 then
        local cueList = table.concat(cuesToAssign, ' + ')
        gma.cmd('Assign Cue ' .. cueList .. ' /MIB=' .. mibValue)
        message('Assigned MIB "' .. mibValue .. '" to Cue(s): ' .. table.concat(cuesToAssign, ', '))
    else
        message('Assigned no MIB to Cues.')
    end
end

return main