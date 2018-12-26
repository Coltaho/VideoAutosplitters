startup
{
	print("--[Autosplitter] Starting up!--");
	
	//Intro
	settings.Add("intro", true, "---Intro---");
	settings.Add("grab", true, "On Grab", "intro");
	
	//8 Mavericks
	// settings.Add("mavs", true, "---Mavericks---");
	// settings.Add("penguin", true, "Penguin", "mavs");
	// settings.Add("mammoth", true, "Mammoth", "mavs");
	// settings.Add("kuwanger", true, "Kuwanger", "mavs");
	// settings.Add("chameleon", true, "Chameleon", "mavs");
	// settings.Add("mandrill", true, "Mandrill", "mavs");
	// settings.Add("eagle", true, "Eagle", "mavs");
	// settings.Add("armadillo", true, "Armadillo", "mavs");
	// settings.Add("octopus", true, "Octopus", "mavs");
	
	//Sigma Bosses
	settings.Add("sigmabosses", true, "---Sigma Bosses---");
	settings.Add("spider", true, "Spider", "sigmabosses");
	settings.Add("rangda", true, "Rangda Bangda", "sigmabosses");
	settings.Add("drex", true, "D-Rex", "sigmabosses");
	settings.Add("wolfsigma", true, "Wolf Sigma", "sigmabosses");
	
	//Hundo Splits
	// settings.Add("hundo", true, "---100%---");
	// settings.Add("penguinheart", false, "Penguin Heart", "hundo");
	// settings.Add("hadouken", true, "Hadouken", "hundo");
	
	settings.Add("infosection", true, "---Info---");
	settings.Add("info", true, "Mega Man X Video Autosplitter v1.0 by Coltaho", "infosection");
	settings.Add("info0", true, "If you get a fade out MANUAL SPLIT REQUIRED duh", "infosection");
	settings.Add("info1", true, "- Website : https://github.com/Coltaho/Autosplitters", "infosection");
		
}

init
{	
	vars.HelmetDingLR = (Func<int, string, bool>)((frame, name) =>
	{
		return (features[frame, name+"_l"].current > 14 || features[frame, name+"_r"].current > 14);
	});
	
	vars.isSigmaDead = (Func<int, bool>)((frame) =>
	{
		return (vars.isFightingSigma && features[frame, "sigma_end"].current > 22);
	});
	
	vars.GetSplitList = (Func<int, Dictionary<string, bool>>)((frame) =>
	{
		var splits = new Dictionary<string, bool>
		{
			//Intro
			{ "grab", (features[frame, "grab1"].current > 14.4) },
			
			//8 Mavericks
			// { "penguin", vars.HelmetDingLR(frame, "penguin") },
			// { "mammoth", vars.HelmetDingLR(frame, "mammoth") },
			// { "kuwanger", vars.HelmetDingLR(frame, "kuwanger") },
			// { "chameleon", vars.HelmetDingLR(frame, "chameleon") },
			// { "mandrill", vars.HelmetDingLR(frame, "mandrill") },
			// { "eagle", vars.HelmetDingLR(frame, "eagle") },
			// { "armadillo", vars.HelmetDingLR(frame, "armadillo") },
			// { "octopus", vars.HelmetDingLR(frame, "octopus") },
			
			//Sigma Bosses
			{ "spider", vars.HelmetDingLR(frame, "spider") },
			{ "rangda", vars.HelmetDingLR(frame, "rangda") },
			{ "drex", vars.HelmetDingLR(frame, "drex") },
			{ "wolfsigma", vars.isSigmaDead(frame) },
			
			//Hundo Splits
			//{ "penguinheart", features["penguinheart"].current > 14 },
			//{ "hadouken", features["hadouken"].current > 14 }			
		};
		return splits;
	});
	
	vars.pastSplits = new HashSet<string>();
	vars.isFightingSigma = false;
	print("--[Autosplitter] Initialization Complete!--");
}

update
{
	//If timer is not running, reset our past splits and other variables
	if (timer.CurrentPhase == TimerPhase.NotRunning && vars.pastSplits.Count > 0) {
		vars.pastSplits.Clear();
		vars.isFightingSigma = false;
		print("--[Autosplitter] Timer reset, clearing past splits and variables");
	}
	
	//Start Sigma fight
	if (!vars.isFightingSigma && features["sigma_start"].current > 22) {
		print("--[Autosplitter] Started Wolf Sigma");
		vars.isFightingSigma = true;
	}

	//Reset Sigma fight if white screen
	if (vars.isFightingSigma && features["flash"].current > 36)	{
		print("--[Autosplitter] Died to Wolf Sigma");
		vars.isFightingSigma = false;
	}
}

start
{
	return features["start1"].current > 13;
}

reset
{
	return features["reset1"].current > 13.5;
}

split
{
	var splits = vars.GetSplitList(features.OriginalIndex);
	foreach (var split in splits)
	{
		if (settings[split.Key] && !vars.pastSplits.Contains(split.Key) && split.Value)
		{
			vars.pastSplits.Add(split.Key);
			print("--[Autosplitter] Split: " + split.Key);
			return true;
		}
	}
}
