---
--- Name:        eclipse-mk/_preload.lua
--- Purpose:     Define the eclipse-mk action
--- Author:      Petr Kalandra
--- Created:     2019/02/15
---

	local p = premake

--
-- Eclipse-mk action
--
	newaction
	{
		trigger         = "eclipse-mk",
		shortname       = "Eclipse-Mk",
		description     = "Generate Eclipse Makefile project files",
		module          = "eclipse-mk",

		valid_kinds     = { "ConsoleApp", "WindowedApp", "StaticLib", "SharedLib", "Utility", "Makefile" },
		valid_languages = { "C", "C++"},
		valid_tools     = {
		    cc          = { "gcc", "clang" }
		},

		onInitialize = function()
			require("eclipse-mk")
		end,
		
		onWorkspace = function(wks)
			-- No workspace
		end,

		onProject = function(prj)
			-- HACKY: Temporarily replace the filename function to generate file without name
			local oldFileName = premake.filename
			premake.filename = function(obj, ext) return ext end			
			premake.generate(prj, ".project", p.modules.eclipse_mk.project.generate)
			premake.generate(prj, ".cproject", p.modules.eclipse_mk.cproject.generate)
			premake.filename = oldFileName
		end,

		onCleanWorkspace = function(wks)
			-- No workspace
		end,

		onCleanProject = function(prj)
			local oldFileName = premake.filename
			premake.filename = function(obj, ext) return ext end	
			premake.clean.file(prj, "..project")
			premake.clean.file(prj, "..cproject")
			premake.filename = oldFileName
		end
	}
	
	newaction
	{
		trigger     = "eclipse-mk-build",
		description = "Build the project from Eclipse CDT",
		execute     = function ()
			local conf = _G["_ARGS"][1]
			print("(1/3) Generating fresh Makefile...")
			os.execute("premake5 gmake2")
						
			if conf == nil then
				print("(2/3) Building Makefile with default...")
				os.execute("make")
			else
				conf = conf:lower()
				print("(2/3) Building Makefile with config '" .. conf .. "'...")
				os.execute("make \"config=" .. conf .. "\"")
			end
			print("(3/3) All done!")
		end
	}

--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return (_ACTION == "eclipse-mk")
	end
	