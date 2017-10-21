
/**
 * Provides a mechanism for downloading arbitrary files from the MCP server
 */
class OnlineTitleFileDownloadMcpSteamworks extends OnlineTitleFileDownloadMcp
	native
	dependson(OnlineSubsystem);

cpptext
{
	/**
	 * Builds the URL to use when fetching the specified file
	 *
	 * @param FileName the file that is being requested
	 *
	 * @return the URL to use with all of the per platform extras
	 */
	virtual FString BuildURLParameters(const FString& FileName);
}
