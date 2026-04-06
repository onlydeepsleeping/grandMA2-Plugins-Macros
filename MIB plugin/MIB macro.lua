-- JB, FG, 2026
-- version: MIB v0.1             - fixed: error when no CueZero (added ::continue::)
--                               - implemented: added message() for user feedback, restructured user configuration

--[[
    overview of variables:
    mV  mibValue
    fQ  firstCue
    c   cleanup (true/false)
    s   sequence (handle)
    nQ  numberCues (number of cues in sequence)
    Q   cue
    mO  mibOld
    qN  cueNumber
    qA  cuesToAssign
    qR  cuesToRemove
]]

-- one liner for use in macro (Unblock Cues first with macro line before)
-- local mV = 'Late' local fQ = 1 local c = true local s = gma.show.getobj.handle('Sequence '..gma.show.getobj.number(gma.user.getselectedexec())) local nQ = gma.show.getobj.amount(s) local qA,qR={},{} function m(m) gma.echo(m) gma.feedback(m) end for i = fQ, nQ do if gma.show.getobj.child(s, i) == nil then goto continue end local Q = gma.show.getobj.child(s, i) local mO = gma.show.property.get(Q, 'MIB') local qN = tonumber(gma.show.getobj.number(Q)) if c and mO ~= '' and mO ~= '*' and qN >= fQ then gma.cmd('Assign Cue '..qN..' /MIB=none') if gma.show.property.get(Q, 'MIB') == '*' then gma.cmd('Assign Cue '..qN..' /MIB='..mO) else table.insert(qR, qN) end end if mO == '*' and qN >= fQ then table.insert(qA, qN) end ::continue:: end if #qR > 0 then m('Removed Cue: '..table.concat(qR, ', ')) else m('Removed no MIB.') end if #qA > 0 then gma.cmd('Assign Cue '..table.concat(qA, ' + ')..' /MIB='..mV) m('Assigned '..mV..' to Cue '..table.concat(qA, ', ')) else m('Assigned no MIB.') end

-- user configuration:
local mV = 'Late'
local fQ = 1
local c = true
local s = gma.show.getobj.handle('Sequence '..gma.show.getobj.number(gma.user.getselectedexec()))
local nQ = gma.show.getobj.amount(s)
local qA,qR={},{}

function m(m) gma.echo(m) gma.feedback(m) end

for i = fQ, nQ do
    if gma.show.getobj.child(s, i) == nil then
        goto continue
    end

    local Q = gma.show.getobj.child(s, i)
    local mO = gma.show.property.get(Q, 'MIB')
    local qN = tonumber(gma.show.getobj.number(Q))

    if c and mO ~= '' and mO ~= '*' and qN >= fQ then
        gma.cmd('Assign Cue '..qN..' /MIB=none')
        if gma.show.property.get(Q, 'MIB') == '*' then
            gma.cmd('Assign Cue '..qN..' /MIB='..mO)
        else
            table.insert(qR, qN)
        end
    end

    if mO == '*' and qN >= fQ then
        table.insert(qA, qN)
    end

    ::continue::
end

if #qR > 0 then
        m('Removed Cue: '..table.concat(qR, ', '))
    else
        m('Removed no MIB.')
    end

    if #qA > 0 then
        gma.cmd('Assign Cue '..table.concat(qA, ' + ')..' /MIB='..mV)
        m('Assigned '..mV..' to Cue '..table.concat(qA, ', '))
    else
        m('Assigned no MIB.')
    end