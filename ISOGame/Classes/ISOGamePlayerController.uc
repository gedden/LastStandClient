class ISOGamePlayerController extends ISOCorePlayerController;


var MapZoneView zview;

/** 
 * Basic Turn state for a player. This allows them
 * to both select and de-select units
 **/
auto state ISOCombatPlayerTurn extends ISOPlayerTurn
{
	/**
	 * Request move. Return true to deselect afterwords
	 **/
	exec function bool onRequestMove(ISOUnit unit, Vector loc)
	{
		// Units dont move, silly rabbit!
		if( unit.IsA('BuildingUnit') )
			return false;

		// Move the unit
		unit.MoveTo(loc);

		return true;
	}

	/**
	 * Select a unit
	 **/
	exec function onSelect(ISOUnit unit)
	{
		super.onSelect(unit);
		BuildMovementPreview();
	}

	/**
	 * Called when a node gets the mouse 
	 * over it
	 **/
	exec function onHoverOver(ISONode node)
	{
		ShowPath();
		/*
		if( selected == none )
			HideMovementPreview();
		else
			BuildMovementPreview();
		*/
	}

	/**
	 * Called when a node no longer has a
	 * mouse over it
	 **/
	exec function onHoverOut(ISONode node)
	{
		//HideMovementPreview();
	}

	/**
	 * Select a unit
	 **/
	exec function onDeselect(ISOUnit unit)
	{
		unit.onDeselect();
		//ISOHUD(myHUD).HideMapZone();
	}

	function BuildMovementPreview()
	{
		local ISOGridController gc;
		gc   = ISOCoreGameInfo(WorldInfo.Game).GetGridController();

		if( selected == none ) return;

		gc.ShowMovementArea(selected);
	}

	function ShowPath()
	{
		local ISOGridController gc;
		local Array<ISONode> path;
		local MapPathZone zone;

		if( selected == none ) return;
		if( hoverNode == none ) return;

		gc   = ISOCoreGameInfo(WorldInfo.Game).GetGridController();

		// Get the movement zone
		zone = gc.GetMovementZone();

		// Build the path
		zone.GetPath(hoverNode, path, gc.grid);
		//`log("Path: " @zone.root.ToString() @ "-->" @ hoverNode.ToString() @path.Length);
		gc.ShowPath(path);
		`log("Showing: "  @hoverNode.ToString() );
		/*
		// Get the movement zone
		zone = gc.GetMovementZone();

		// Build the path
		path = zone.GetPath(hoverNode, gc.grid);
		`log(path.Length);
		gc.ShowPath(path);
		*/
	}

	/*
	function BuildPathView()
	{
		local MapZone zone;
		local ISOGridController gc;
		local Array<ISONode> path;

		// Cant build a movement zone for nothing!
		if( selected == none ) return;
		
		// Build the map zone
		gc   = ISOCoreGameInfo(WorldInfo.Game).GetGridController();

		zone = class'MapZone'.static.Create(selected.GetNode(), selected.speed, gc.grid, selected);		

		// COnstruct a path
		if( hoverNode != none )
		{
			//path = zone.GetPath( hoverNode, gc.grid);
		}

		gc.DrawMapZone(zone, path);
	}
	*/

	function HideMovementPreview()
	{
		ISOCoreGameInfo(WorldInfo.Game).GetGridController().HideMovementArea();
	}
}

DefaultProperties
{
}
