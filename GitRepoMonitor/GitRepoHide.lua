function ShowRepo(i)
   SKIN:Bang("!ShowMeter", "Repo"..i.."Label")
   SKIN:Bang("!ShowMeter", "MeterRepo"..i.."Changes")
   SKIN:Bang("!ShowMeter", "MeterRepo"..i.."Unpushed")
   SKIN:Bang("!ShowMeter", "MeterRepo"..i.."Unpulled")
   local Name = SKIN:GetVariable("Repo"..i.."Name")
   print("[GitRepoMonitor] Showing repository "..i.." ("..Name..")")


end

function HideRepo(i)
   SKIN:Bang("!HideMeter", "Repo"..i.."Label")
   SKIN:Bang("!HideMeter", "MeterRepo"..i.."Changes")
   SKIN:Bang("!HideMeter", "MeterRepo"..i.."Unpushed")
   SKIN:Bang("!HideMeter", "MeterRepo"..i.."Unpulled")
end

function SpaceRepo(i)
   local label = SKIN:GetMeter("Repo"..i.."Label")
   local labelY = label:GetY()
   local changes = SKIN:GetMeter("MeterRepo"..i.."Changes")
   local changesY = changes:GetY()
   local unpushed = SKIN:GetMeter("MeterRepo"..i.."Unpushed")
   local unpushedY = unpushed:GetY()
   local unpulled = SKIN:GetMeter("MeterRepo"..i.."Unpulled")
   local unpulledY = unpulled:GetY()
   local space = SKIN:GetVariable("SpacingY")
   label:SetY(labelY + (i-1)*space)
   changes:SetY(changesY + (i-1)*space)
   unpushed:SetY(unpushedY + (i-1)*space)
   unpulled:SetY(unpulledY + (i-1)*space)
end

function Initialize()
   for i=1, tonumber(SKIN:GetVariable("MaxRepos")) do
      SpaceRepo(i)
   end
end

function Update()
   local repos=0
   for i=1, tonumber(SKIN:GetVariable("MaxRepos")) do
      local repo = "Repo"..i
      local path = SKIN:GetVariable(repo.."Path")
      if path and path ~= "" then
	 -- SKIN:Bang("!CommandMeasure", "Repo"..i.."Measure", "Run")
	 SKIN:Bang("!CommandMeasure", "Repo"..i.."Changes", "Run")
	 SKIN:Bang("!CommandMeasure", "Repo"..i.."Unpulled", "Run")
	 SKIN:Bang("!CommandMeasure", "Repo"..i.."Unpushed", "Run")
	 ShowRepo(i)
	 repos=repos+1
      else
	 HideRepo(i)
      end
   end
   local space = SKIN:GetVariable("SpacingY")
   local height = (tonumber(repos) * tonumber(space))+20
   SKIN:Bang("!SetVariable", "BackgroundHeight", height)
   
   print("[GitRepoMonitor] Updated "..repos.." repositories.")
   SKIN:Bang("!Redraw")
end
