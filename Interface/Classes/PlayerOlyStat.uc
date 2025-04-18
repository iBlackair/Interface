class PlayerOlyStat extends UICommonAPI;

var WindowHandle 	Me;

var TextBoxHandle	statWins,
					statLoses,
					statWR,
					statWinStreak,
					statMaxStreak;
					
var ButtonHandle	btnClose;
var ButtonHandle	btnRefresh;

var int				w,l,wr,ws,ms;

function OnRegisterEvent()
{
}

function OnLoad()
{
	Me = GetWindowHandle("PlayerOlyStat");
	statWins = GetTextBoxHandle("PlayerOlyStat.statWins");
	statLoses = GetTextBoxHandle("PlayerOlyStat.statLoses");
	statWR = GetTextBoxHandle("PlayerOlyStat.statWR");
	statWinStreak = GetTextBoxHandle("PlayerOlyStat.statWinStreak");
	statMaxStreak = GetTextBoxHandle("PlayerOlyStat.statMaxStreak");
	btnClose = GetButtonHandle("PlayerOlyStat.btnClose");
	btnRefresh = GetButtonHandle("PlayerOlyStat.btnRefresh");

	ShowStat();
}

function ShowStat()
{
	GetINIInt("Stats", "Wins", w, "MySets");
	GetINIInt("Stats", "Loses", l, "MySets");
	GetINIInt("Stats", "WinRate", wr, "MySets");
	GetINIInt("Stats", "WinStreak", ws, "MySets");
	GetINIInt("Stats", "MaxStreak",ms, "MySets");
	
	statWins.SetText( "Wins:" @ string( w ) );
	statLoses.SetText( "Loses:" @ string( l ) ); 
	statWR.SetText( "Winrate:" @ string( wr ) $ "%" ); 
	statWinStreak.SetText( "Win Streak:" @ string( ws ) );
	statMaxStreak.SetText( "Max Win Streak:" @ string( ms ) );
}

function RefreshStat()
{
	SetINIInt("Stats", "Wins", 0, "MySets");
	SetINIInt("Stats", "Loses", 0, "MySets");
	SetINIInt("Stats", "WinRate", 0, "MySets");
	SetINIInt("Stats", "WinStreak", 0, "MySets");
	SetINIInt("Stats", "MaxStreak", 0, "MySets");
	
	statWins.SetText( "Wins:" @ string( 0 ) );
	statLoses.SetText( "Loses:" @ string( 0 ) ); 
	statWR.SetText( "Winrate:" @ string( 0 ) $ "%" ); 
	statWinStreak.SetText( "Win Streak:" @ string( 0 ) );
	statMaxStreak.SetText( "Max Win Streak:" @ string( 0 ) );
}

function OnClickButton( string strID )
{
	switch (strID)
	{
		case "btnClose":
			Me.HideWindow();
		break;
		case "btnRefresh":
			RefreshStat();
		break;
		default:
		break;
	}
}

defaultproperties
{
}