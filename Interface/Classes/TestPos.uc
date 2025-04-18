class TestPos extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle Btn;

var OnScreenDmg script;

var int gX, gY;

function OnLoad()
{
	Me = GetWindowHandle("TestPos");
	Btn = GetButtonHandle("TestPos.Btn");

	script = OnScreenDmg(GetScript("OnScreenDmg"));

}

function OnRegisterEvent ()
{
	RegisterEvent(580);
}

function OnEvent (int a_EventID, string a_Param)
{
  
  switch (a_EventID)
  {
	case 580:
		TestPos();
	break;
    default:
    break;
  }
}

function OnClickButton( String strID )
{
	switch (strID)
	{
		case "Btn":
			TestPos();
		break;
	}
}

function TestPos()
{
	local Actor actorPlayer;
	local Actor tempActor;
	local UserInfo uInfo;
	local vector CamLoc;
	local vector Dir;
	local vector Right;
	local vector Up;
	local vector Repos;
	local rotator CamRot;
	local int width;
	local int height;
	local float X, Y;
	local float LengthBufferZ;

	sysDebug("TEST");

	actorPlayer = GetPlayerActor();
	if (!GetTargetInfo(uInfo)) return;
	GetCurrentResolution(width, height);
	GetAxes(CamRot, Dir, Right, Up);

	//sysDebug("Width: " @ width @ "Height: " @ height);

	Repos = uInfo.Loc - CamLoc; sysDebug("TargetLoc: " @ uInfo.Loc.X @ uInfo.Loc.Y @ uInfo.Loc.Z );
	//sysDebug("CamLoc: " @ CamLoc.X @ CamLoc.Y @ CamLoc.Z );
	//sysDebug("Repos: " @ Repos.X @ Repos.Y @ Repos.Z );
	LengthBufferZ = Repos Dot Dir;
	//sysDebug("LengthBufferZ: " @ LengthBufferZ);
	//sysDebug("Right: " @ Right.X @ Right.Y @ Right.Z);
	//sysDebug("Up: " @ Up.X @ Up.Y @ Up.Z);
	X = (Repos Dot Right / LengthBufferZ) * width;
	Y = (Repos Dot Up / LengthBufferZ) * height;

	//sysDebug("Debug: X=" @ X @ "Y=" @ Y);

	gX = int(X);
	gY = int(Y);

	if (gX < 0)
	{
		gX = (width / 2) + gX;
		sysDebug("X Neg: " $ gX );
	}
	else
	{
		gX = (width / 2) + gX;
		sysDebug("X Posit: " $ gX );
	}

	if (gY < 0)
	{
		gY = (height / 2) + gY;
		sysDebug("Y Neg: " $ gY );
	}
	else
	{
		gY = (height / 2) + gY;
		sysDebug("Y Posit: " $ gY );
	}

	gY = height - gY;

	if (gX < width && gY < height)
		script.MainDmg.MoveTo( gX, gY );
		//script.MainDmg.SetAnchor( "OnScreenDmg", "TopLeft", "TopLeft", gX, gY );

}