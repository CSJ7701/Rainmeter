function Initialize()
    configPath = SKIN:GetVariable("RepoConfigPath")
    scriptOutputPath = SKIN:GetVariable("ScriptOutputPath")
    iconSize = tonumber(SKIN:GetVariable("IconSize"))

    repos = LoadRepos(configPath)
    GenerateMeters(repos)
end

-- Parse the repos.ini file for repository configurations
function LoadRepos(configPath)
    local repos = {}
    local currentRepo = nil

    for line in io.lines(configPath) do
        local section = line:match("^%[(.-)%]$")
        local key, value = line:match("^(.-)=(.-)$")
        if section then
            currentRepo = {Name = section}
            table.insert(repos, currentRepo)
        elseif currentRepo and key and value then
            currentRepo[key] = value
        end
    end

    return repos
end

-- Generate meters dynamically based on the repositories
function GenerateMeters(repos)
    local yOffset = 40
    for i, repo in ipairs(repos) do
        local meterName = "Repo" .. i
        local labelName = meterName .. "Label"

        -- Add a label for the repo name
        SKIN:Bang('!SetOption', labelName, 'Meter', 'String')
        SKIN:Bang('!SetOption', labelName, 'Text', repo.Name)
        SKIN:Bang('!SetOption', labelName, 'X', '10')
        SKIN:Bang('!SetOption', labelName, 'Y', tostring(yOffset))
        SKIN:Bang('!SetOption', labelName, 'FontColor', '#TextColor#')
        SKIN:Bang('!UpdateMeter', labelName)

        -- Add a clickable action to open the repo folder
        SKIN:Bang('!SetOption', meterName, 'Meter', 'Image')
        SKIN:Bang('!SetOption', meterName, 'SolidColor', '128,128,128')
        SKIN:Bang('!SetOption', meterName, 'W', '300')
        SKIN:Bang('!SetOption', meterName, 'H', tostring(iconSize))
        SKIN:Bang('!SetOption', meterName, 'X', '10')
        SKIN:Bang('!SetOption', meterName, 'Y', tostring(yOffset + 20))
        SKIN:Bang('!SetOption', meterName, 'LeftMouseUpAction', '["' .. repo.Path .. '"]')
        SKIN:Bang('!UpdateMeter', meterName)

        yOffset = yOffset + 40  -- Increment for next repo
    end
    SKIN:Bang('!Redraw')
end
