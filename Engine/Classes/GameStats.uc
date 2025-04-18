// ====================================================================
//  Class:  Engine.GameStats
//  Parent: Engine.Info
//
//  the GameStats object is used to send individual stat events to the
//  stats server.  Each game should spawn a GameStats object if it 
//  wishes to have stat logging.
//
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class GameStats extends Info
		Native;

var FileLog TempLog;		
var GameReplicationInfo GRI;
var bool bShowBots;			//!! FIXME - remove before ship!!!

native final function string GetStatsIdentifier( Controller C );
native final function string GetMapFileName();	// Returns the name of the current map

/////////////////////////////////////
// GameStats interface

function Init()
{
	TempLog = spawn(class 'FileLog');
	if (TempLog!=None)
	{
		TempLog.OpenLog("Stats");
		log("Output Game stats to: STATS.TXT");
	}
	else
	{
		log("Could not spawn Temporary Stats log");
		Destroy();
	}
}
function Shutdown()
{
	if (TempLog!=None) 
		TempLog.Destroy();
}
function Logf(string LogString)
{
	if (TempLog!=None)
		TempLog.Logf(LogString);
} 

/////////////////////////////////////
// Internals

event PostBeginPlay()
{
	Super.PostBeginPlay();
	Init();
}

event Destroyed()
{
	Shutdown();	
	Super.Destroyed();	
}

function string TimeStamp()
{
	local string seconds;
	seconds = ""$Level.TimeSeconds;

	// Remove the centiseconds
	if( InStr(seconds,".") != -1 )
		seconds = Left( seconds, InStr(seconds,".") );

	return seconds;
}

function string Header()
{
	return ""$TimeStamp()$chr(9);
}

function String FullTimeDate()		// Date/Time in MYSQL format
{
	return ""$Level.Year$"-"$Level.Month$"-"$Level.Day$" "$Level.Hour$":"$Level.Minute$":"$Level.Second;
} 

function String TimeZone()			// Timezone (offset) of game server's local time to GTM, e.g. -4 or +5
{
	return "0";						// FIXME Jack - currently pretending GMT
} 

function String MapName()
{

	local string mapname;
	mapname = ""$GetMapFileName();

	// Remove the file name extention .ut2
	if( InStr(mapname,".ut2") != -1 )
		mapname = Left( mapname, InStr(mapname,".ut2") );

	return mapname;
} 


// Stat Logging functions
function NewGame()
{
	local string out,tmp;
	local int i;
	local mutator MyMutie;
	local GameRules MyRules;

	GRI = Level.Game.GameReplicationInfo;
	out = Header()$"NG"$chr(9);				// "NewGame"
	out = out$FullTimeDate()$Chr(9);		// Game server's local time
	out = out$TimeZone()$Chr(9);			// Game server's time zone (offset to GMT)
	out = out$MapName()$Chr(9);				// Map file name without map extention .ut2
	out = out$Level.Title$chr(9);
	out = out$Level.Author$chr(9);
	out = out$Level.Game.Class$chr(9);
	out = out$Level.Game.GameName;
	
	tmp = "";
	i = 0;
	foreach AllActors(class'Mutator',MyMutie)
	{
		if (tmp!="")
			tmp=tmp$"|"$MyMutie.Class;
		else
	 		tmp=""$MyMutie.Class;

		i++;
	}		
	foreach AllActors(class 'GameRules',MyRules)
	{
		if (tmp!="")
			tmp=tmp$"|"$MyRules.Class;
		else
			tmp=""$MyRules.Class;
			
		i++;
	}		

	if (i>0)
		out = out$chr(9)$"Mutators="$tmp;

	Logf(out);
}

function ServerInfo()
{
	local string out;
	local GameInfo.ServerResponseLine ServerState;
	local int i;

	out = Header()$"SI"$chr(9);				// "SeverInfo"
	out = out$GRI.ServerName$chr(9);		// Server name
	out = out$TimeZone()$chr(9);			// Timezone
	out = out$GRI.AdminName$chr(9);			// Admin name
	out = out$GRI.AdminEmail$chr(9);		// Admin email
	out = out$chr(9);						// IP:port (filled in by M.S.)
	Level.Game.GetServerDetails( ServerState );
	for( i=0;i<ServerState.ServerInfo.Length;i++ )
		out = out$"\\"$ServerState.ServerInfo[i].Key$"\\"$ServerState.ServerInfo[i].Value;
	Logf(out);
}

function StartGame()
{
	Logf( ""$Header()$"SG" );			// "StartGame"
}


// Send stats for the end of the game
function EndGame(string Reason)
{
	local string out;
	local int i,j;
	local GameReplicationInfo GRI;
	local array<PlayerReplicationInfo> PRIs;
	local PlayerReplicationInfo PRI,t;

	out = Header()$"EG"$Chr(9)$Reason;	// "EndGame"

	GRI = Level.Game.GameReplicationInfo;

	// Quick cascade sort.
	for (i=0;i<GRI.PRIArray.Length;i++)
	{
		PRI = GRI.PRIArray[i];
		if (!PRI.bOnlySpectator)
		{
			PRIs.Length = PRIs.Length+1;
			for (j=0;j<Pris.Length-1;j++)
			{
				if (PRIs[j].Score < PRI.Score ||
				   (PRIs[j].Score == PRI.Score && PRIs[j].Deaths > PRI.Deaths) )
				{
					t = PRIs[j];
					PRIs[j] = PRI;
					PRI = t;
				}
			}
			PRIs[j] = PRI;
		}
	}
	
	// Minimal scoreboard, shows Playernumbers in order of Score
	for (i=0;i<PRIs.Length;i++)
	{
		out = out$chr(9)$Controller(PRIs[i].Owner).PlayerNum;
	}
		
	Logf(out);
}	


// Connect Events get fired every time a player connects to a server
function ConnectEvent(PlayerReplicationInfo Who)
{
	local string out;
	if ( Who.bBot && !bShowBots  )
		return;

	// C	0	11d8944d9e138a5aa688d503e0e4c3e0
	out = ""$Header()$"C"$Chr(9)$Controller(Who.Owner).PlayerNum$Chr(9);

	// Login identifier
	out = out$GetStatsIdentifier(Controller(Who.Owner));

	Logf(out);
}

// Connect Events get fired every time a player connects or leaves from a server
function DisconnectEvent(PlayerReplicationInfo Who)
{
	local string out;
	if ( Who.bBot && !bShowBots  )
		return;

	// D	0	
	out = ""$Header()$"D"$Chr(9)$Controller(Who.Owner).PlayerNum;	//"Disconnect"

	Logf(out);
}


// Scoring Events occur when a player's score changes
function ScoreEvent(PlayerReplicationInfo Who, float Points, string Desc)
{
	if ( Who.bBot && !bShowBots  )
		return;
	Logf( ""$Header()$"S"$chr(9)$Controller(Who.Owner).PlayerNum$chr(9)$Points$chr(9)$Desc );	//"Score"
}


function TeamScoreEvent(int Team, float Points, string Desc)
{
	Logf( ""$Header()$"T"$Chr(9)$Team$Chr(9)$Points$Chr(9)$Desc );	//"TeamScore"
}


// KillEvents occur when a player kills, is killed, suicides
function KillEvent(string Killtype, PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> Damage)
{
	local string out;
	if ( Victim.bBot && !bShowBots )
		return;
	out = ""$Header()$Killtype$Chr(9);

	// KillerNumber and KillerDamagetype
	if (Killer!=None)
	{
		if ( Killer.bBot && !bShowBots  )
			return;
		out = out$Controller(Killer.Owner).PlayerNum$Chr(9);
		// KillerWeapon no longer used, using damagetype
		out = out$GetItemName(string(Damage))$Chr(9);
	}
	else
		out = out$"-1"$chr(9)$GetItemName(string(Damage))$Chr(9);		// No PlayerNum -> -1, Environment "deaths"

	// VictimNumber and VictimWeapon
	out = out$Controller(Victim.Owner).PlayerNum$chr(9)$GetItemName(string(Controller(Victim.Owner).Pawn.Weapon));

	// Type killers tracked as player event (redundant Typing, removed from kill line)
	if ( PlayerController(Victim.Owner)!= None && PlayerController(Victim.Owner).bIsTyping)
	{
		if ( PlayerController(Killer.Owner) != PlayerController(Victim.Owner) )	
			SpecialEvent(Killer, "type_kill");		//Killer killed typing victim (suicide typing ignored!)
	}

	Logf(out);
}


// Special Events are everything else regarding the player
function SpecialEvent(PlayerReplicationInfo Who, string Desc)
{
	local string out;
	if (Who != None)
	{
		if ( Who.bBot && !bShowBots  )
			return;
		out = ""$Controller(Who.Owner).PlayerNum;
	}
	else
		out = "-1";

	Logf( ""$Header()$"P"$Chr(9)$out$Chr(9)$Desc );					//"PSpecial"
}


// Special events regarding the game
function GameEvent(string GEvent, string Desc, PlayerReplicationInfo Who)
{
	local string out;
	if (Who != None)
	{
		if ( Who.bBot && !bShowBots  )
			return;
		out = ""$Controller(Who.Owner).PlayerNum;
	}
	else
		out = "-1";

	Logf( ""$Header()$"G"$Chr(9)$GEvent$Chr(9)$out$Chr(9)$Desc );	//"GSpecial"
}

defaultproperties
{
}
