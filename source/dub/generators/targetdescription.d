/**
	Pseudo generator to output build descriptions.

	Copyright: © 2015 rejectedsoftware e.K.
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
	Authors: Sönke Ludwig
*/
module dub.generators.targetdescription;

import dub.description;
import dub.generators.generator;
import dub.project;

class TargetDescriptionGenerator : ProjectGenerator {
	TargetDescription[] targetDescriptions;
	TargetDescription[string] targetDescriptionLookup;

	//PackageDescription[] packageDescriptions;
	//PackageDescription[string] packageDescriptionLookup;

	this(Project project)
	{
		super(project);
	}

	protected override void generateTargets(GeneratorSettings settings, in TargetInfo[string] targets)
	{
//import dub.internal.vibecompat.inet.path;
//import dub.compilers.buildsettings;
//import dub.compilers.compiler;
//import dub.internal.utils;
		/+bool[string] visited;
		void buildTargetRec(string target)
		{
			if (target in visited) return;
			visited[target] = true;

			auto ti = targets[target];

			foreach (dep; ti.dependencies)
				buildTargetRec(dep);

			Path[] additional_dep_files;
			auto bs = ti.buildSettings.dup;
			foreach (ldep; ti.linkDependencies) {
				auto dbs = targets[ldep].buildSettings;
				if (bs.targetType != TargetType.staticLibrary) {
					bs.addSourceFiles((Path(dbs.targetPath) ~ getTargetFileName(dbs, settings.platform)).toNativeString());
				} else {
					additional_dep_files ~= Path(dbs.targetPath) ~ getTargetFileName(dbs, settings.platform);
				}
			}
			//TODO: do something with additional_dep_files
			//buildTarget(settings, bs, ti.pack, ti.config, ti.packages, additional_dep_files);
		}+/

		// build all targets
		//auto root_ti = targets[m_project.rootPackage.name];
		//if(root_ti.buildSettings.targetType != TargetType.staticLibrary) {
		//	buildTargetRec(m_project.rootPackage.name);
		//}

		auto configs = m_project.getPackageConfigs(settings.platform, settings.config);
		
		targetDescriptions.length = targets.length;
		size_t i = 0;
		foreach (t; targets) {
			TargetDescription d;
			d.rootPackage = t.pack.name;
			d.packages = t.packages.map!(p => p.name).array;
			d.rootConfiguration = t.config;
			d.buildSettings = t.buildSettings.dup;
			d.dependencies = t.dependencies.dup;
			d.linkDependencies = t.linkDependencies.dup;

			/+foreach (pack; t.packages) {
				if (pack.name !in packageDescriptionLookup) {
					auto packDesc = pack.describe(settings.platform, configs[pack.name]);
					packageDescriptionLookup[pack.name] = packDesc;
					packageDescriptions ~= packDesc;
				}
			}+/
/+
//			Path[] additional_dep_files;
			auto bs = t.buildSettings.dup;
			foreach (ldep; t.linkDependencies) {
import std.stdio;
writeln("FOUND LINK DEP: ", ldep);
				auto dbs = targets[ldep].buildSettings;
				if (bs.targetType != TargetType.staticLibrary) {
writeln("      LINK DEP A: ", (Path(dbs.targetPath) ~ getTargetFileName(dbs, settings.platform)).toNativeString());
					bs.addLibs((Path(dbs.targetPath) ~ getTargetFileName(dbs, settings.platform)).toNativeString());
					d.buildSettings = bs;
				}// else {
//writeln("      LINK DEP B: ", Path(dbs.targetPath) ~ getTargetFileName(dbs, settings.platform));
//					additional_dep_files ~= Path(dbs.targetPath) ~ getTargetFileName(dbs, settings.platform);
//					bs.libs ~= (Path(dbs.targetPath) ~ getTargetFileName(dbs, settings.platform)).toString();
//					d.buildSettings = bs;
//				}
			}
			//TODO: do something with additional_dep_files
+/
			targetDescriptionLookup[d.rootPackage] = d;
			targetDescriptions[i++] = d;
		}
	}
}
