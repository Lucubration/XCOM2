/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Base class for stats read and write objects. Contains common structures
 * and methods used by both read and write objects.
 */
class OnlineStats extends Object
	native
	abstract;

// FIRAXIS begin: -tsmith
/**
 * Maps a view and property to a Steam column ID.
 * Need to map stat property ID of the write property to the column ID of the read propertyG
 * so both stats read and stat write have the same api_name that the Steam backend uses.
 */
struct native ViewPropertyToColumnId
{
	/** The id of the view */
	var int ViewId;
	/** The id of the property */
	var int PropertyId;
	/** The id of the stat read column for this property */
	var int ColumnId;
};
// moved this from the Steamworks code so that we can have a general interface function to set mapping.
// this allows us to enforce compile time checks on the ViewId as opposed to having it in an INI. -tsmith 
/** Maps a ViewId (as used by OnlineStats* classes) to a Steam leaderboard name */
struct native ViewIdToLeaderboardName
{
	/** The id of the view */
	var int ViewId;

	/** The leaderboard name */
	var string LeaderboardName;
};
// FIRAXIS end: -tsmith

/** Provides metadata view ids so that we can present their human readable form */
var const array<StringIdToStringMapping> ViewIdMappings;

/**
 * Searches the view id mappings to find the view id that matches the name
 *
 * @param ViewName the name of the view being searched for
 * @param ViewId the id of the view that matches the name
 *
 * @return true if it was found, false otherwise
 */
native function bool GetViewId(name ViewName,out int ViewId);

/**
 * Finds the human readable name for the view
 *
 * @param ViewId the id to look up in the mappings table
 *
 * @return the name of the view that matches the id or NAME_None if not found
 */
native function name GetViewName(int ViewId);
