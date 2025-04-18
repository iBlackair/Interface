class AutoSS extends UICommonAPI;

const LOOP_COUNT = 1;

var WindowHandle Me;
var ItemWindowHandle Shot1;
var ItemWindowHandle Shot2;
var ItemWindowHandle RHand;
var ItemWindowHandle InvItem;
var AnimTextureHandle Animation1;
var AnimTextureHandle Animation2;
var TextureHandle texBG2;

var ItemInfo EquippedWeapon;
var ItemInfo SoulShot;
var ItemInfo SpiritShot;

var int soulIndex;
var int spiritIndex;

var bool isUsedSoul;
var bool isUsedSpirit;
var bool isExistSoul;
var bool isExistSpirit;
var bool isAttacking;

var bool isPlayerDead;

var SkillInfo UsedSkill;

function OnLoad()
{
	Me = GetWindowHandle("AutoSS");
	Shot1 = GetItemWindowHandle("AutoSS.Item1");
	Shot2 = GetItemWindowHandle("AutoSS.Item2");
	Animation1 = GetAnimTextureHandle("AutoSS.Anim1");
	Animation2 = GetAnimTextureHandle("AutoSS.Anim2");
	texBG2 = GetTextureHandle("AutoSS.BGSpirit");
	
	RHand = GetItemWindowHandle( "InventoryWnd.EquipItem_RHand" );
	InvItem = GetItemWindowHandle( "InventoryWnd.InventoryItem" );
	
	isPlayerDead = false;
}

function OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_ReceiveMagicSkillUse);
	RegisterEvent(EV_ReceiveAttack);
	RegisterEvent(EV_OlympiadTargetShow);
	RegisterEvent( EV_Die );
}

function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	
}

function AnchorShots(string window, int x, int y)
{
	Me.SetAnchor(window, "TopLeft", "TopLeft", x, y);
}

function OnShow()
{
	local AutoSouls script_as;
	script_as = AutoSouls(GetScript("AutoSouls"));
	script_as.SetPosition();
	EnterTheVoid();
}

function SetSSPosition()
{
	local bool IsExpand1;
	local bool IsExpand2;
	local bool IsExpand3;
	local bool IsExpand4;
	local bool IsExpand5;
	
	local bool isVertical;
	
	isVertical = GetOptionBool( "Game", "IsShortcutWndVertical" );
	
	IsExpand1 = GetOptionBool( "Game", "Is1ExpandShortcutWnd" );
	IsExpand2 = GetOptionBool( "Game", "Is2ExpandShortcutWnd" );
	IsExpand3 = GetOptionBool( "Game", "Is3ExpandShortcutWnd" );
	IsExpand4 = GetOptionBool( "Game", "Is4ExpandShortcutWnd" );
	IsExpand5 = GetOptionBool( "Game", "Is5ExpandShortcutWnd" );
	
	if (!isVertical)
	{
		Me.SetWindowSize(54, 24);
		Animation2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 30, 0);
		Shot2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 29, -1);
		texBG2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 30, 0);
		
		if (IsExpand5)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_5", 36, -34);
		}	
		else if (IsExpand4)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_4", 36, -34);
		}
			
		else if (IsExpand3)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_3", 36, -34);
		}
		else if (IsExpand2)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_2", 36, -34);
		}
			
		else if (IsExpand1)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_1", 36, -34);
		}
			
		else
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal", 36, -34);
		}
	}
	else
	{
		Me.SetWindowSize(24, 54);
		Animation2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 30);
		Shot2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , -1, 29);
		texBG2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 30);
		
		if (IsExpand5)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_5", -34, 34);
		}	
		else if (IsExpand4)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_4", -34, 34);
		}
			
		else if (IsExpand3)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_3", -34, 34);
		}
		else if (IsExpand2)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_2", -34, 34);
		}
			
		else if (IsExpand1)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_1", -34, 34);
		}
			
		else
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical", -34, 34);
		}
	}
	
}

function OnEvent( int EventID, String param )
{

	switch(EventID)
	{
		case EV_GamingStateEnter:
			SetSSPosition();
			//Me.ShowWindow();
		break;
		case EV_UpdateUserInfo:
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
				EnterTheVoid();
		break;
		case EV_ReceiveMagicSkillUse:
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
				SkillCast(param);
		break;
		case EV_ReceiveAttack:
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
				Attack(param);
		break;
		case EV_Die:
			OnDieEvent(param);
		break;
		}
}

function OnDieEvent(string param)
{
	isPlayerDead = true;
}

function bool isSoulSkill(int skillid)
{
	switch (skillid)
	{
		case 2039:
		case 2150:
		case 2151:
		case 2152:
		case 2153:
		case 2154:
			return true;
		default:
			return false;
		break;
	}
}

function bool isSpiritSkill(int skillid)
{
	switch (skillid)
	{
		case 2061:
		case 2160:
		case 2161:
		case 2162:
		case 2163:
		case 2164:
			return true;
		default:
			return false;
		break;
	}
}

function SkillCast (string a_Param)
{
	local int AttackerID;
	local int SkillID;
	local int SkillLevel;
	local float SkillHitTime;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	local int SkillHitTime_ms;

	ParseInt(a_Param,"AttackerID",AttackerID);
	ParseInt(a_Param,"SkillID",SkillID);
	ParseInt(a_Param,"SkillLevel",SkillLevel);
	ParseFloat(a_Param,"SkillHitTime",SkillHitTime);
	  
	if ( SkillHitTime > 0 )
		SkillHitTime_ms = int(SkillHitTime * 1000) + 300;
	else
		SkillHitTime_ms = 100;
	
	//sysDebug("1st time: "$SkillHitTime_ms);
	  
	GetUserInfo(AttackerID,AttackerInfo);
	GetPlayerInfo(PlayerInfo);
	  
	GetSkillInfo( SkillID, SkillLevel, UsedSkill );
	
	isAttacking = false;
	
	if (UsedSkill.IsMagic == 0 && !UsedSkill.IsDebuff && UsedSkill.OperateType == 1)
		return;
	
	if (PlayerInfo.nID == AttackerID && !isSoulSkill(SkillID) && !isSpiritSkill(SkillID))
	{
		Me.KillTimer(1112);
		isUsedSoul = false;
		isUsedSpirit = false;
		Me.SetTimer(1112, SkillHitTime_ms + 50);
		//sysDebug("TIMER SET");
		//sysDebug("isUsedSoul"@ isUsedSoul);
		//sysDebug("isUsedSpirit"@ isUsedSpirit);
	}
	else if (PlayerInfo.nID == AttackerID && isSoulSkill(SkillID))
	{
		isUsedSoul = true;
		Me.KillTimer(1112);
		//sysDebug("TIMER STOPPED");
		//sysDebug("USED SOULSHOT");
	}
	else if	(PlayerInfo.nID == AttackerID && isSpiritSkill(SkillID))
	{
		isUsedSpirit = true;
		Me.KillTimer(1112);
		//sysDebug("TIMER STOPPED");
		//sysDebug("USED SPIRITSHOT");
	}	
	 
}

function Attack (string a_Param)
{
	local int AttackerID;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	//local PetInfo PetInfo;


	ParseInt(a_Param,"AttackerID",AttackerID);
	  
	GetUserInfo(AttackerID,AttackerInfo);
	GetPlayerInfo(PlayerInfo);
	
	isAttacking = true;
	
	if (PlayerInfo.nID == AttackerID)
	{
		Me.KillTimer(1112);
		isUsedSoul = false;
		isUsedSpirit = false;
		Me.SetTimer(1112, 50);
	}
}

function OnTimer(int TimerID)
{
	local UserInfo check;
	local UserInfo kek;
	
	if (GetPlayerInfo(check))
	{
		if (check.nCurHP <= 0)
		{
			Me.KillTimer(1112);	
			return;
		}
	}
	
	GetTargetInfo(kek);
	
	switch (TimerID)
	{
		case 1112:
			if (!isUsedSoul && isExistSoul && UsedSkill.IsMagic == 0 && (UsedSkill.IsDebuff || UsedSkill.OperateType == 0) )
			{
				InvItem.GetItem(soulIndex, SoulShot);
				if (SoulShot.ItemNum > IntToInt64(0))
				{
					if (kek.nID > 0)
					{
						//RequestTargetUser(kek.nID);
					}
					RequestUseItem(SoulShot.ID);
				}
				else
				{
					StopOne();
				}
				//sysDebug("REQUEST SOUL");
			}	
			if (!isUsedSpirit && isExistSpirit && !isAttacking && UsedSkill.IsMagic == 1)
			{
				InvItem.GetItem(spiritIndex, SpiritShot);
				if (SpiritShot.ItemNum > IntToInt64(0))
				{
					if (kek.nID > 0)
					{
						//RequestTargetUser(kek.nID);
					}
					RequestUseItem(SpiritShot.ID);
				}
				else
				{
					StopTwo();
				}
				//sysDebug("REQUEST SPIRIT");
			}

			Me.KillTimer(1112);	
			Me.SetTimer(1112, 50);
		break;
	}
}


function bool GetEquippedWeapon()
{
	if (RHand.GetItem(0, EquippedWeapon))
		return true;
	else 
		return false;
}

function int GetSpiritShotID(int weapGrade)
{
	switch (GetGradeByIndex(weapGrade))
	{
		case 'NOGRADE':
			return 3947;
		break;
		case 'D':
			return 3948;
		break;
		case 'C':
			return 3949;
		break;
		case 'B':
			return 3950;
		break;
		case 'A':
			return 3951;
		break;
		case 'S':
			return 3952;
		break;
	}
}

function int GetSoulShotID(int weapGrade)
{
	switch (GetGradeByIndex(weapGrade))
	{
		case 'NOGRADE':
			return 1835;
		break;
		case 'D':
			return 1463;
		break;
		case 'C':
			return 1464;
		break;
		case 'B':
			return 1465;
		break;
		case 'A':
			return 1466;
		break;
		case 'S':
			return 1467;
		break;
	}
}

function FindAllShotsByWeapGrade(int weapGrade)
{
	local ItemID SoulShotID;
	local ItemID SpiritShotID;
	
	SoulShotID.ClassID = GetSoulShotID(weapGrade);
	SpiritShotID.ClassID = GetSpiritShotID(weapGrade);
	
	soulIndex = InvItem.FindItem( SoulShotID );
	spiritIndex = InvItem.FindItem( SpiritShotID );
}

function name GetGradeByIndex(int weapIndex)
{
	switch (weapIndex)
	{
		case 0:
			return 'NOGRADE';
		break;
		case 1:
			return 'D';
		break;
		case 2:
			return 'C';
		break;
		case 3:
			return 'B';
		break;
		case 4:
			return 'A';
		break;
		case 5:
		case 6:
		case 7:
			return 'S';
		break;
	}
}

function StartAnimOne()
{
	Animation1.Stop();
	Animation1.SetLoopCount(-1);
	Animation1.Play();
}

function StartAnimTwo()
{
	Animation2.Stop();
	Animation2.SetLoopCount(-1);
	Animation2.Play();
}

function AddSoulShot(int index)
{
	local ItemInfo soulInfo;
	
	InvItem.GetItem(index, soulInfo);
	Shot1.Clear();
	Shot1.AddItem(soulInfo);
	StartAnimOne();
	RequestAutoSoulShots(index);
	isExistSoul = true;
}

function AddSpiritShot(int index)
{
	local ItemInfo spiritInfo;
	
	InvItem.GetItem(index, spiritInfo);
	Shot2.Clear();
	Shot2.AddItem(spiritInfo);
	StartAnimTwo();
	RequestAutoSoulShots(index);
	isExistSpirit = true;
}

function StopOne()
{
	Animation1.Stop();
	Shot1.Clear();
	isExistSoul = false;
}

function StopTwo()
{
	Animation2.Stop();
	Shot2.Clear();
	isExistSpirit = false;
}

function EnterTheVoid()
{
	if (GetEquippedWeapon())
	{
		FindAllShotsByWeapGrade(EquippedWeapon.CrystalType);
		
		if (soulIndex != -1)
			AddSoulShot(soulIndex);
		else
			StopOne();
	
		if (spiritIndex != -1)
			AddSpiritShot(spiritIndex);	
		else
			StopTwo();
	}
	else
	{
		StopOne();
		StopTwo();
	}
}

function RequestAutoSoulShots(int index)
{
	
	if (index == soulIndex)
	{
		InvItem.GetItem(index, SoulShot);
		//sysDebug("GOT ITEM DATA - SOUL");
		RequestUseItem(SoulShot.ID);
	}
	else if (index == spiritIndex)
	{
		InvItem.GetItem(index, SpiritShot);
		//sysDebug("GOT ITEM DATA - SPIRIT");
		RequestUseItem(SpiritShot.ID);
	}
}