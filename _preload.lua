--
-- Name:        android/_preload.lua
-- Purpose:     Define the Android API's.
-- Author:      Manu Evans
-- Copyright:   (c) 2013-2015 Manu Evans and the Premake project
--

	require "vstudio"

	local p = premake
	local api = p.api

--
-- Register the Android extension
--

	p.ANDROID = "android"
	p.ANDROIDPROJ = "androidproj"

	api.addAllowed("system", p.ANDROID)
	api.addAllowed("architecture", { "armv5", "armv7", "aarach64", "mips", "mips64", "arm", "arm64" })
	api.addAllowed("vectorextensions", { "NEON", "MXU" })
	api.addAllowed("flags", { "Thumb" })
	api.addAllowed("kind", p.ANDROIDPROJ)

	premake.action._list["vs2015"].valid_kinds = table.join(premake.action._list["vs2015"].valid_kinds, { p.ANDROIDPROJ })
	premake.action._list["vs2017"].valid_kinds = table.join(premake.action._list["vs2017"].valid_kinds, { p.ANDROIDPROJ })

	-- TODO: can I api.addAllowed() a key-value pair?
	local os = p.fields["os"];
	if os ~= nil then
		table.insert(sys.allowed, { "android",  "Android" })
	end


--
-- Register Android properties
--

	api.register {
		name = "floatabi",
		scope = "config",
		kind = "string",
		allowed = {
			"soft",
			"softfp",
			"hard",
		},
	}

	api.register {
		name = "androidapilevel",
		scope = "config",
		kind = "integer",
	}

	api.register {
		name = "androidprojectversion",
		scope = "config",
		kind = "string",
		allowed = {
			"1.0",
			"2.0",
			"3.0",
		}
	}

	api.register {
		name = "toolchainversion",
		scope = "config",
		kind = "string",
		allowed = function (value)
			-- Warn the user of a known invalid option
			if _ACTION < "vs2015" then
				if (value >= "4.6" and value <= "4.9") or (value >= "3.4" and value <= "3.6") then
					p.warn("The provided value might not be supported!")
				end
			end

			-- Don't limit the value arbitrarily as the available options
			-- change between implementations
			return value
		end,
	}

	api.register {
		name = "stl",
		scope = "config",
		kind = "string",
		allowed = {
			"none",
			"minimal",
			"c++",
			"stlport",
			"gnu stl",
			"stdc++",
			"llvm libc++",
		},
		aliases = {
			["stdc++"] = "gnu stl",
		},
	}

	api.register {
		name = "thumbmode",
		scope = "config",
		kind = "string",
		allowed = {
			"thumb",
			"arm",
			"disabled",
		},
	}
