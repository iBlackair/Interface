class SaveLoadParty extends UICommonAPI;

var WindowHandle Me;

var ButtonHandle BtnSave;
var ButtonHandle BtnLoad;
var ButtonHandle BtnStop;

var TextBoxHandle Log;

var Color WhiteC;

var int MemberIDs[9];
var string MemberNamesUnsorted[9];
var string MemberNames[9];
var int InviteStatus;
var int GlobalCount;
var string GlobalName;

function OnRegisterEvent()
{
	RegisterEvent(EV_SystemMessage);
	RegisterEvent(EV_GamingStateEnter);
}

function OnLoad()
{	
	InitHandles();

	BtnStop.HideWindow();

	WhiteC.R = 225; WhiteC.G = 225; WhiteC.B = 225; 
	Log.SetText("Party Control");
	Log.SetTextColor(WhiteC);
}

function InitHandles()
{
	Me = GetWindowHandle("SaveLoadParty");

	BtnSave = GetButtonHandle("SaveLoadParty.btnSave");
	BtnLoad = GetButtonHandle("SaveLoadParty.btnLoad");
	BtnStop = GetButtonHandle("SaveLoadParty.btnStop");

	Log = GetTextBoxHandle("SaveLoadParty.Log");
}

function OnEvent(int EventID, string param)
{
	switch (EventID)
	{
		case EV_SystemMessage:
			if (Me.IsShowWindow()) GetMessage(param);
		break;
		case EV_GamingStateEnter:
			LoadInfo();
		break;
	}
}

function OnClickButtonWithHandle(ButtonHandle Button)
{
	switch (Button)
	{
		case BtnSave:
			Log.SetText("Party Control");
			Log.SetTextColor(WhiteC);
			SavePartyList();
		break;
		case BtnLoad:
			if (GlobalCount > 0)
			{
				BtnStop.ShowWindow();
				BtnLoad.HideWindow();
				SortPartyList(MemberNamesUnsorted, MemberNames);
				LoadPartyMember(false);
				Me.SetTimer(113, 1000);
			}
			else
			{
				AddLogRecord("Not saved!", "Red");
			}
		break;
		case BtnStop:
			InviteStatus = -1;
			Me.KillTimer(113);
			BtnStop.HideWindow();
			BtnLoad.ShowWindow();
			Log.SetText("Stopped");
			Log.SetTextColor(WhiteC);
		break;
	}
}

function OnTimer(int TimerID)
{
	switch (TimerID)
	{
		case 113:
			if (InviteStatus == 0) // Invite sended
			{
				Me.KillTimer(113);
				Me.SetTimer(113, 1000);
				//sysDebug("WAITING TO ACCEPT INVITE...");
			}
			else if (InviteStatus == 1) // Invite accepted
			{
				Me.KillTimer(113);
				if (GetPartyMemberCount() != GlobalCount)
				{
					AddLogRecord("INVITED - " $ GlobalName, "Green");
					LoadPartyMember(false);
					Me.SetTimer(113, 1000);
					//sysDebug("INVITE ACCEPTED - LOADING NEXT...");
				}
				else
				{
					//sysDebug("PARTY RECOVERED!");
					AddLogRecord("PARTY RECOVERED!", "Green");
					BtnStop.HideWindow();
					BtnLoad.ShowWindow();
					InviteStatus = -1;
				}
			}
			else if (InviteStatus == 2) // Declined
			{
				Me.KillTimer(113);
				if (GetPartyMemberCount() != GlobalCount)
				{
					AddLogRecord("INVITE DECLINED - " $ GlobalName, "Red");
					LoadPartyMember(true, FindNextMemberName(GlobalName));
					Me.SetTimer(113, 1000);
					//sysDebug("INVITE DECLINED - LOADING NEXT AFTER " $ GlobalName $ "...");
				}
				else
				{
					//sysDebug("PARTY RECOVERED!");
					AddLogRecord("PARTY RECOVERED!", "Green");
					BtnStop.HideWindow();
					BtnLoad.ShowWindow();
					InviteStatus = -1;
				}
			}
		break;
	}
}

function AddLogRecord(string Text, string ColorStr)
{
	local Color White;
	local Color Green;
	local Color Red;

	White.R = 225; White.G = 225; White.B = 225;
	Green.R = 0; Green.G = 185; Green.B = 0;
	Red.R = 185; Red.G = 45; Red.B = 75;

	switch (ColorStr)
	{
		case "White":
			Log.SetText( Text );
			Log.SetTextColor( White );
		break;
		case "Green":
			Log.SetText( Text );
			Log.SetTextColor( Green );
		break; 
		case "Red":
			Log.SetText( Text );
			Log.SetTextColor( Red );
		break; 
	}
}

function LoadInfo()
{
	local int idx;
	local int Count;

	GetINIInt("PartyList", "Count", Count, "PatchSettings");

	for (idx = 0; idx < Count; idx++)
		GetINIString("PartyList", "Member_" $ string(idx), MemberNamesUnsorted[idx], "PatchSettings");
}

function SavePartyList()
{
	local int idx;
	local int MemberCount;
	local PartyWnd PW;

	MemberCount = GetPartyMemberCount();

	GlobalCount = MemberCount;

	if (MemberCount > 0)
	{
		PW = PartyWnd(GetScript("PartyWnd"));

		for (idx = 0; idx < 9; idx++)
		{
			MemberIDs[idx] = -1;
			MemberNamesUnsorted[idx] = "";
		}

		for (idx = 0; idx < MemberCount; idx++)
		{
			MemberIDs[idx] = PW.m_arrID[idx];
			MemberNamesUnsorted[idx] = PW.m_PlayerName[idx].GetName();
			SetINIString("PartyList", "Member_" $ string(idx), MemberNamesUnsorted[idx], "PatchSettings");
		}

		SetINIInt("PartyList", "Count", MemberCount, "PatchSettings");

		AddLogRecord("Party Saved", "Green");
	}
	else
	{
		MessageBox("You are not in party!");
	}
}

function SortPartyList(string List[9], out string NewListString[9])
{
	local int NewList[9];
	local int idx;
	local int idy;
	local string TempName;
	local int TempID;
	local UserInfo info;

	for (idx = 0; idx < 9; idx++)
	{
		NewList[idx] = MemberIDs[idx];
		NewListString[idx] = List[idx];
	}

	//sysDebug("BEFORE SORT");

	//for (idx = 0; idx < 9; idx++)
		//sysDebug("ID: " $ string(MemberIDs[idx]) $ " Name: " $ MemberNamesUnsorted[idx]);

	for (idx = 0; idx < GlobalCount; idx++)
	{
		if (!GetUserInfo(MemberIDs[idx], info)) // If not exist
		{
			for (idy = idx; idx < GlobalCount - 1; idx++)
			{
				TempName = NewListString[idy];
				NewListString[idy] = NewListString[idy + 1];
				NewListString[idy + 1] = TempName;
			}
		}
	}

	for (idx = 0; idx < GlobalCount; idx++)
	{
		if (!GetUserInfo(MemberIDs[idx], info)) // If not exist
		{
			for (idy = idx; idx < GlobalCount - 1; idx++)
			{
				TempID = NewList[idy];
				NewList[idy] = NewList[idy + 1];
				NewList[idy + 1] = TempID;
			}
		}
	}

	for (idx = 0; idx < 9; idx++)
		MemberIDs[idx] = NewList[idx];

	//sysDebug("AFTER SORT");

	//for (idx = 0; idx < 9; idx++)
		//sysDebug("ID: " $ string(NewList[idx]) $ " Name: " $ NewListString[idx]);
}

function string FindNextMemberName(string PrevName)
{
	local int idx;

	for (idx = 0; idx < GlobalCount; idx++)
	{
		if (idx == GlobalCount - 1)
			return MemberNames[0];
		if (MemberNames[idx] == PrevName)
			return MemberNames[idx + 1];
	}
}

function LoadPartyMember(bool LoadNext, optional string NextName)
{
	local int idx;
	local int idy;
	local int MemberCount;
	local int IndexNext;
	local bool PlayerExist;
	local PartyWnd PW;

	MemberCount = GetPartyMemberCount();

	PW = PartyWnd(GetScript("PartyWnd"));

	if (LoadNext)
	{
		for (idx = 0; idx < 9; idx++)
		{
			if (MemberNames[idx] != NextName)
				continue;
			else
				IndexNext = idx;
		}

		//sysDebug("NEXT NAME " $ NextName);

		for (idx = IndexNext; idx < 9; idx++)
		{
			
			if (MemberNames[idx] != "")
			{
				PlayerExist = false;

				for (idy = 0; idy < MemberCount; idy++)
					if (MemberNames[idx] == PW.m_PlayerName[idy].GetName())
					{
						PlayerExist = true;
						break;
					}

				if (!PlayerExist)
				{
					RequestInviteParty( MemberNames[idx] );
					AddLogRecord("INVITE SENT TO - " $ MemberNames[idx], "White");
					break;
				}
			}
		}
	}
	else
	{
		for (idx = 0; idx < 9; idx++)
		{
			if (MemberNames[idx] != "")
			{
				PlayerExist = false;

				for (idy = 0; idy < MemberCount; idy++)
					if (MemberNames[idx] == PW.m_PlayerName[idy].GetName())
					{
						PlayerExist = true;
						break;
					}

				//sysDebug("PLayer: " $ MemberNames[idx] $ " Exist? - " $ string(PlayerExist));

				if (!PlayerExist)
				{
					RequestInviteParty( MemberNames[idx] );
					AddLogRecord("INVITE SENT TO - " $ MemberNames[idx], "White");
					break;
				}	
			}
		}
	}
}

function GetMessage(string param)
{
	local int MsgID;
	local string MemberName;

	ParseInt(param, "Index", MsgID);

	//105 - $c1 has been invited to the party.
	//107 - $c1 has joined the party.
	//305 - The player declined to join your party.

	//Status: 0 - 105, 1 - 107, -1 - Smth else

	if (MsgID == 105)
	{
		ParseString(param, "Param1", MemberName);
		GlobalName = MemberName;
		InviteStatus = 0;
		//sysDebug("<< INVITED >>");
	}
	else if (MsgID == 107)
	{
		//ParseString(param, "Param1", MemberName);
		InviteStatus = 1;
		//sysDebug("<< JOINED >>");
	}
	else if (MsgID == 305)
	{
		InviteStatus = 2;
		//sysDebug("<< DECLINED >>");
	}
}

