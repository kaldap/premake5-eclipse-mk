---
--- Name:        eclipse-mk/eclipse-mk_cproject.lua
--- Purpose:     Generate Eclipse CDT Makefile based '.cproject' file
--- Author:      Petr Kalandra
--- Created:     2019/02/15
---
	function premake.modules.eclipse_mk.cproject.generate_config(prj, configName, baseUID, _id)
		local myId = _id()
		local tchId = _id()
		if baseUID then
			myId = baseUID .. "." .. myId
		end
		if not configName then
			makeArgs = ""
			configName = "Default"
		else
			makeArgs = ' arguments="config=' .. configName:lower() .. '" command="make"'
		end
	
		_p(2, 	'<cconfiguration id="0.%s">', myId)
		
		_p(3, 	'<storageModule buildSystemId="org.eclipse.cdt.managedbuilder.core.configurationDataProvider" id="0.%s" moduleId="org.eclipse.cdt.core.settings" name="%s">', myId, configName)
		_p(4, 		'<externalSettings/>')
		_p(4, 		'<extensions>')
		_p(5,			'<extension id="org.eclipse.cdt.core.VCErrorParser" point="org.eclipse.cdt.core.ErrorParser"/>')
		_p(5,			'<extension id="org.eclipse.cdt.core.GmakeErrorParser" point="org.eclipse.cdt.core.ErrorParser"/>')
		_p(5,			'<extension id="org.eclipse.cdt.core.CWDLocator" point="org.eclipse.cdt.core.ErrorParser"/>')
		_p(5,			'<extension id="org.eclipse.cdt.core.GCCErrorParser" point="org.eclipse.cdt.core.ErrorParser"/>')
		_p(5,			'<extension id="org.eclipse.cdt.core.GASErrorParser" point="org.eclipse.cdt.core.ErrorParser"/>')
		_p(5,			'<extension id="org.eclipse.cdt.core.GLDErrorParser" point="org.eclipse.cdt.core.ErrorParser"/>')
		_p(4, 		'</extensions>')
		_p(3, 	'</storageModule>')
		
		_p(3, 	'<storageModule moduleId="cdtBuildSystem" version="4.0.0">')
		_p(4, 		'<configuration buildProperties="" description="" id="0.%s" name="%s" parent="org.eclipse.cdt.build.core.prefbase.cfg">', myId, configName)
		_p(5,			'<folderInfo id="0.%s." name="/" resourcePath="">', myId)
		_p(6,				'<toolChain id="org.eclipse.cdt.build.core.prefbase.toolchain.%d" name="No ToolChain" resourceTypeBasedDiscovery="false" superClass="org.eclipse.cdt.build.core.prefbase.toolchain">', tchId)
		_p(7,					'<targetPlatform id="org.eclipse.cdt.build.core.prefbase.toolchain.%d.%d" name=""/>', tchId, _id())
		_p(7,					'<builder%s id="org.eclipse.cdt.build.core.settings.default.builder.%d" keepEnvironmentInBuildfile="false" managedBuildOn="false" name="Gnu Make Builder" superClass="org.eclipse.cdt.build.core.settings.default.builder"/>', makeArgs, _id())
		_p(7,					'<tool id="org.eclipse.cdt.build.core.settings.holder.libs.%d" name="holder for library settings" superClass="org.eclipse.cdt.build.core.settings.holder.libs"/>', _id())
		_p(7,					'<tool id="org.eclipse.cdt.build.core.settings.holder.%d" name="Assembly" superClass="org.eclipse.cdt.build.core.settings.holder">', _id())
		_p(8,						'<inputType id="org.eclipse.cdt.build.core.settings.holder.inType.%d" languageId="org.eclipse.cdt.core.assembly" languageName="Assembly" sourceContentType="org.eclipse.cdt.core.asmSource" superClass="org.eclipse.cdt.build.core.settings.holder.inType"/>', _id())
		_p(7,					'</tool>')
		_p(7,					'<tool id="org.eclipse.cdt.build.core.settings.holder.%d" name="GNU C++" superClass="org.eclipse.cdt.build.core.settings.holder">', _id())
		_p(8,						'<inputType id="org.eclipse.cdt.build.core.settings.holder.inType.%d" languageId="org.eclipse.cdt.core.g++" languageName="GNU C++" sourceContentType="org.eclipse.cdt.core.cxxSource,org.eclipse.cdt.core.cxxHeader" superClass="org.eclipse.cdt.build.core.settings.holder.inType"/>', _id())
		_p(7,					'</tool>')
		_p(7,					'<tool id="org.eclipse.cdt.build.core.settings.holder.%d" name="GNU C" superClass="org.eclipse.cdt.build.core.settings.holder">', _id())
		_p(8,						'<inputType id="org.eclipse.cdt.build.core.settings.holder.inType.%d" languageId="org.eclipse.cdt.core.gcc" languageName="GNU C" sourceContentType="org.eclipse.cdt.core.cSource,org.eclipse.cdt.core.cHeader" superClass="org.eclipse.cdt.build.core.settings.holder.inType"/>', _id())
		_p(7,					'</tool>')
		_p(6,				'</toolChain>')
		_p(5,			'</folderInfo>')
		_p(4, 		'</configuration>')
		_p(3, 	'</storageModule>')
		
		_p(3, 	'<storageModule moduleId="org.eclipse.cdt.core.externalSettings"/>')
		_p(2, 	'</cconfiguration>')
	
		return myId
	end


	function premake.modules.eclipse_mk.cproject.generate(prj)
		local _id = premake.modules.eclipse_mk.newUID		
		local toolchainUID = _id()
		local toolchainSubUID = _id()
		local confNames = {}
		local defConfUID = 0
		local defConfName = "Default"
		for cfg in premake.project.eachconfig(prj) do
			table.insert(confNames, cfg.buildcfg)
		end
			
		premake.eol("\r\n")
		premake.indent("\t")
		premake.escaper(premake.modules.eclipse_mk.esc)

		_p('<?xml version="1.0" encoding="UTF-8" standalone="no"?>')
		_p('<?fileVersion 4.0.0?>')
		_p('<cproject storage_type_id="org.eclipse.cdt.core.XmlProjectDescriptionStorage">')

		_p(1, '<storageModule moduleId="org.eclipse.cdt.core.settings">')
		if #confNames > 0 then
			defConfName = confNames[1]
			defConfUID = premake.modules.eclipse_mk.cproject.generate_config(prj, defConfName, nil, _id)						
			for ix,buildcfg in ipairs(confNames) do
				if ix > 1 then
					premake.modules.eclipse_mk.cproject.generate_config(prj, buildcfg, defConfUID, _id)
				end
			end
		end
		_p(1, '</storageModule>')
		
		_p(1, '<storageModule moduleId="cdtBuildSystem" version="4.0.0">')
		_x(2, 	'<project id="%s.null.%d" name="%s"/>', prj.name, _id(), prj.name)
		_p(1, '</storageModule>')
		
		_p(1, '<storageModule moduleId="scannerConfiguration">')
		_p(2, 	'<autodiscovery enabled="true" problemReportingEnabled="true" selectedProfileId=""/>')
		_p(2, 	'<scannerConfigBuildInfo instanceId="ilg.gnuarmeclipse.managedbuild.cross.toolchain.base.%d;ilg.gnuarmeclipse.managedbuild.cross.toolchain.base.%d.%d;ilg.gnuarmeclipse.managedbuild.cross.tool.c.compiler.%d;ilg.gnuarmeclipse.managedbuild.cross.tool.c.compiler.input.%d">', toolchainUID, toolchainUID, toolchainSubUID, _id(), _id())
		_p(3,		'<autodiscovery enabled="true" problemReportingEnabled="true" selectedProfileId=""/>')
		_p(2, 	'</scannerConfigBuildInfo>')
		_p(2, 	'<scannerConfigBuildInfo instanceId="0.%d">', defConfUID)
		_p(3,		'<autodiscovery enabled="true" problemReportingEnabled="true" selectedProfileId=""/>')
		_p(2, 	'</scannerConfigBuildInfo>')
		_p(2, 	'<scannerConfigBuildInfo instanceId="ilg.gnuarmeclipse.managedbuild.cross.toolchain.base.%d;ilg.gnuarmeclipse.managedbuild.cross.toolchain.base.%d.%d;ilg.gnuarmeclipse.managedbuild.cross.tool.cpp.compiler.%d;ilg.gnuarmeclipse.managedbuild.cross.tool.cpp.compiler.input.%d">', toolchainUID, toolchainUID, toolchainSubUID, _id(), _id())
		_p(3,		'<autodiscovery enabled="true" problemReportingEnabled="true" selectedProfileId=""/>')
		_p(2, 	'</scannerConfigBuildInfo>')
		_p(1, '</storageModule>')
		
		_p(1, '<storageModule moduleId="refreshScope" versionNumber="2">')
		_p(2, 	'<configuration configurationName="%s">', defConfName)
		_x(3,		'<resource resourceType="PROJECT" workspacePath="/%s"/>', prj.name)
		_p(2, 	'</configuration>')
		_p(1, '</storageModule>')
		
		_p(1, '<storageModule moduleId="org.eclipse.cdt.core.LanguageSettingsProviders"/>')
		_p(1, '<storageModule moduleId="org.eclipse.cdt.internal.ui.text.commentOwnerProjectMappings"/>')		
		_p('</cproject>')
	end
