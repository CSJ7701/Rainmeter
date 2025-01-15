function Update()
   print(1, "GitStatus.lua: Initialize function is running.")
   
   repos={}
   for i=1, tonumber(SKIN:GetVariable("MaxRepos")) do
      local repo = "Repo" .. i
      local name = SKIN:GetVariable(repo .. "Name")
      local path = SKIN:GetVariable(repo .. "Path")
      local remote = SKIN:GetVariable(repo .. "Remote")
      local status = SKIN:GetVariable(repo .. "Status")

      SKIN:Bang("!CommandMeasure", "Repo"..i.."Measure", "Run")

      if path and path ~= "" then
	 table.insert(repos, { Path = path, Remote = remote, Status = status })
	 SKIN:Bang("!ShowMeter", repo .. "Label")
         SKIN:Bang("!ShowMeter", repo .. "Status")

	 local updatedStatus = GetRepoStatus(i)
	 print("Repo"..i.."Measure: " .. updatedStatus)
	 SKIN:Bang("!SetOption", repo .. "Label", "Text", name)
         SKIN:Bang("!SetOption", repo .. "Status", "Text", "Status: " .. updatedStatus)
      else
         SKIN:Bang("!HideMeter", repo .. "Label")
         SKIN:Bang("!HideMeter", repo .. "Status")
      end
   end
   print(1, "GitStatus.lua: Repos Initialized. Total repos: " .. tostring(#repos))
   SKIN:Bang("!Redraw")
end


function GetRepoStatus(repoIndex)
   -- Wait briefly for the measure to update
   -- os.execute("CHOICE /n /d:y /c:yn /t:5")
   -- Get the output of the git status command for this repo
   local measure = "Repo"..repoIndex.."Measure"
   local statusMeasure = SKIN:GetMeasure(measure)
   local statusOutput = statusMeasure:GetStringValue()
   print("Got Measure value: " .. statusOutput)
   
   return statusOutput
end
