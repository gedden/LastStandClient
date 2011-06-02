/*****************************************
 * Main Entry point for the core of the 
 * game play portion of the game client.
 * 
 * So it beings. ~ag
 ****************************************/
class ISOMapBuilder extends ISOCoreGameInfo;

DefaultProperties
{
	PlayerControllerClass   = class'ISOMapBuilder.ISOMapBuilderPlayer'
	HUDType                 = class'ISOMapBuilder.ISOBuilderHUD'
	GridClass               = class'ISOMapBuilder.ISOBuilderGrid'
}


event PostLogin( PlayerController NewPlayer )
{
    super.PostLogin(NewPlayer);
    NewPlayer.ClientMessage("Welcome to the ISOCore "$NewPlayer.PlayerReplicationInfo.PlayerName);

	NewPlayer.GotoState('ISOPlayerEdit');
}