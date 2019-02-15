---
--- Name:        eclipse-mk/eclipse_mk.lua
--- Purpose:     Define the Eclipse_mk action(s).
--- Author:      Petr Kalandra
--- Created:     2019/02/15
---

	local p = premake

	p.modules.eclipse_mk = {}

	local eclipse_mk = p.modules.eclipse_mk

	eclipse_mk.compiler  = {}
	eclipse_mk.platforms = {}
	eclipse_mk.project   = {}
	eclipse_mk.cproject  = {}
	eclipse_mk.uidSeq    = 10000 * math.random(10000)
	
	function eclipse_mk.newUID()
		eclipse_mk.uidSeq = eclipse_mk.uidSeq + 1
		return eclipse_mk.uidSeq
	end
	
	function eclipse_mk.esc(value)		
		return value -- No escaping
	end

	include("_preload.lua")
	include("eclipse-mk_cproject.lua")
	include("eclipse-mk_project.lua")
	
	return eclipse_mk
