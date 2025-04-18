class UICommonAPI extends UIScriptEx;

const EV_USER_CharacterSelectionChanged = 50000;

//FileWnd FileHandler TYPE
enum _FileHandler
{
	FH_NONE,
	FH_PLEDGE_CREST_UPLOAD,
	FH_PLEDGE_EMBLEM_UPLOAD,
	FH_ALLIANCE_CREST_UPLOAD,
	FH_MAX
	// 파일윈도우에서 파일을 처리할 함수를 정하고 싶을때 용도에 따라 추가합시다 
};

// Dialog API
enum EDialogType
{
	DIALOG_OKCancel,
	DIALOG_OK,
	DIALOG_OKCancelInput,
	DIALOG_OKInput,
	DIALOG_Warning,
	DIALOG_Notice,
	DIALOG_NumberPad,
	DIALOG_Progress,
};
enum EDialogModalType
{
	DIALOG_Modal,
	DIALOG_Modalless,
};

enum DialogDefaultAction
{
	EDefaultNone,
	EDefaultOK,
	EDefaultCancel,
};

struct x4423
{
	var array<string> digest;
};

struct HSVColor
{
	var() float H, S, V, A;
};


function ShowOnScreenMessage(int msgType, int msgNo, int windowType, int fontType, color MsgColor, int lifeTime, string MessageText)
{
	local string out_Param;
	
	ParamAdd( out_Param, "MsgType",         string(msgType) );
	ParamAdd( out_Param, "MsgNo",           string(msgNo) );
	ParamAdd( out_Param, "WindowType",      string(windowType) );
	ParamAdd( out_Param, "FontSize",        "20" );
	ParamAdd( out_Param, "FontType",        string(fontType) );
	
	ParamAdd( out_Param, "MsgColor",        "1" );
	ParamAdd( out_Param, "MsgColorR",       string(MsgColor.R));
	ParamAdd( out_Param, "MsgColorG",       string(MsgColor.G));
	ParamAdd( out_Param, "MsgColorB",       string(MsgColor.B));
	ParamAdd( out_Param, "ShadowType",      "0" );
	ParamAdd( out_Param, "BackgroundType",  "0" );
	ParamAdd( out_Param, "LifeTime",        string(lifeTime) );
	ParamAdd( out_Param, "AnimationType",   "1" );
	ParamAdd( out_Param, "Msg",             MessageText );
	
	ExecuteEvent(EV_ShowScreenMessage, out_Param);
}

function bool IsNoble(int m_skillID)
{
	local bool	bIsNoblessID;
	bIsNoblessID = false;
	switch( m_skillID )
	{
		case 1323:
			 bIsNoblessID = true;
			 break;
	}	
	return bIsNoblessID;
}


function int intPercent(int what, int from)
{
	return (float(what) / float(from))*100;
}

function float getPercent(int what, int from)
{
	return float(what) / float(from);
}

function printUserInfo(UserInfo a_UserInfo)
{
	AddSystemMessageString("nID"@a_UserInfo.nID);
	AddSystemMessageString("Name"@a_UserInfo.Name);
	AddSystemMessageString("strNickName"@a_UserInfo.strNickName);
	AddSystemMessageString("RealName"@a_UserInfo.RealName);
	AddSystemMessageString("nSex"@a_UserInfo.nSex);
	AddSystemMessageString("Class"@a_UserInfo.Class);
	AddSystemMessageString("nLevel"@a_UserInfo.nLevel);
	AddSystemMessageString("nClassID"@a_UserInfo.nClassID);
	AddSystemMessageString("nSubClass"@a_UserInfo.nSubClass);
	AddSystemMessageString("nSP"@a_UserInfo.nSP);
	AddSystemMessageString("nCurHP"@a_UserInfo.nCurHP);
	AddSystemMessageString("nMaxHP"@a_UserInfo.nMaxHP);
	AddSystemMessageString("nCurMP"@a_UserInfo.nCurMP);
	AddSystemMessageString("nMaxMP"@a_UserInfo.nMaxMP);
	AddSystemMessageString("nCurCP"@a_UserInfo.nCurCP);
	AddSystemMessageString("nMaxCP"@a_UserInfo.nMaxCP);
	//AddSystemMessageString("nCurExp"@a_UserInfo.nCurExp);
	
	AddSystemMessageString("nUserRank"@a_UserInfo.nUserRank);
	AddSystemMessageString("nClanID"@a_UserInfo.nClanID);
	AddSystemMessageString("nAllianceID"@a_UserInfo.nAllianceID);
	AddSystemMessageString("nCarryWeight"@a_UserInfo.nCarryWeight);
	AddSystemMessageString("nCarringWeight"@a_UserInfo.nCarringWeight);
	
	AddSystemMessageString("nPhysicalAttack"@a_UserInfo.nPhysicalAttack);
	AddSystemMessageString("nPhysicalDefense"@a_UserInfo.nPhysicalDefense);
	AddSystemMessageString("nHitRate"@a_UserInfo.nHitRate);
	AddSystemMessageString("nCriticalRate"@a_UserInfo.nCriticalRate);
	AddSystemMessageString("nPhysicalAttackSpeed"@a_UserInfo.nPhysicalAttackSpeed);
	AddSystemMessageString("nMagicalAttack"@a_UserInfo.nMagicalAttack);
	AddSystemMessageString("nMagicDefense"@a_UserInfo.nMagicDefense);
	AddSystemMessageString("nPhysicalAvoid"@a_UserInfo.nPhysicalAvoid);
	AddSystemMessageString("nWaterMaxSpeed"@a_UserInfo.nWaterMaxSpeed);
	AddSystemMessageString("nWaterMinSpeed"@a_UserInfo.nWaterMinSpeed);
	AddSystemMessageString("nAirMaxSpeed"@a_UserInfo.nAirMaxSpeed);
	AddSystemMessageString("nAirMinSpeed"@a_UserInfo.nAirMinSpeed);
	AddSystemMessageString("nGroundMaxSpeed"@a_UserInfo.nGroundMaxSpeed);
	AddSystemMessageString("nGroundMinSpeed"@a_UserInfo.nGroundMinSpeed);
	AddSystemMessageString("fNonAttackSpeedModifier"@a_UserInfo.fNonAttackSpeedModifier);
	AddSystemMessageString("nMagicCastingSpeed"@a_UserInfo.nMagicCastingSpeed);
	
	AddSystemMessageString("nStr"@a_UserInfo.nStr);
	AddSystemMessageString("nDex"@a_UserInfo.nDex);
	AddSystemMessageString("nCon"@a_UserInfo.nCon);
	AddSystemMessageString("nInt"@a_UserInfo.nInt);
	AddSystemMessageString("nWit"@a_UserInfo.nWit);
	AddSystemMessageString("nMen"@a_UserInfo.nMen);
	
	AddSystemMessageString("nCriminalRate"@a_UserInfo.nCriminalRate);
	AddSystemMessageString("nDualCount"@a_UserInfo.nDualCount);
	AddSystemMessageString("nPKCount"@a_UserInfo.nPKCount);
	AddSystemMessageString("nSociality"@a_UserInfo.nSociality);
	AddSystemMessageString("nRemainSulffrage"@a_UserInfo.nRemainSulffrage);
	
	AddSystemMessageString("bHero"@a_UserInfo.bHero);
	AddSystemMessageString("bNobless"@a_UserInfo.bNobless);
	AddSystemMessageString("bNpc"@a_UserInfo.bNpc);
	AddSystemMessageString("bPet"@a_UserInfo.bPet);
	AddSystemMessageString("bCanBeAttacked"@a_UserInfo.bCanBeAttacked);
	
	AddSystemMessageString("Loc"@a_UserInfo.Loc);

	// 캐릭터 속성 - lancelot 2007. 5. 18.
	AddSystemMessageString("AttrAttackType"@a_UserInfo.AttrAttackType);
	AddSystemMessageString("AttrAttackValue"@a_UserInfo.AttrAttackValue);
	AddSystemMessageString("AttrDefenseValFire"@a_UserInfo.AttrDefenseValFire);
	AddSystemMessageString("AttrDefenseValWater"@a_UserInfo.AttrDefenseValWater);
	AddSystemMessageString("AttrDefenseValWind"@a_UserInfo.AttrDefenseValWind);
	AddSystemMessageString("AttrDefenseValEarth"@a_UserInfo.AttrDefenseValEarth);
	AddSystemMessageString("AttrDefenseValHoly"@a_UserInfo.AttrDefenseValHoly);
	AddSystemMessageString("AttrDefenseValUnholy"@a_UserInfo.AttrDefenseValUnholy);
	
	// 변신
	AddSystemMessageString("nTransformID"@a_UserInfo.nTransformID);
	AddSystemMessageString("m_bPawnChanged"@a_UserInfo.m_bPawnChanged);
	
	//Inven Item Order, ttmayrin
	AddSystemMessageString("nInvenLimit"@a_UserInfo.nInvenLimit);

	// 2008/03/05 PvP Point Restrain - NeverDie
	AddSystemMessageString("PvPPointRestrain"@a_UserInfo.PvPPointRestrain);

	// 2008/03/05 PvP Point - NeverDie
	AddSystemMessageString("PvPPoint"@a_UserInfo.PvPPoint);

	AddSystemMessageString("NicknameColor"@a_UserInfo.NicknameColor.R@a_UserInfo.NicknameColor.G@a_UserInfo.NicknameColor.B);

	AddSystemMessageString("nVitality"@a_UserInfo.nVitality);

	// Decoy - anima
	AddSystemMessageString("nMasterID"@a_UserInfo.nMasterID);

	// 2008/8/4 Talisman Num
	AddSystemMessageString("nTalismanNum"@a_UserInfo.nTalismanNum);
	// 2008/8/7 FullArmor Check
	AddSystemMessageString("nFullArmor"@a_UserInfo.nFullArmor);

	AddSystemMessageString("JoinedDominionID"@a_UserInfo.JoinedDominionID);		// lancelot 2008. 8. 28.
	AddSystemMessageString("WantHideName"@a_UserInfo.WantHideName);
	AddSystemMessageString("DominionIDForVirtualName"@a_UserInfo.DominionIDForVirtualName);
	
	// EXP percent rate - 2010/05/19 sori
	AddSystemMessageString("fExpPercentRate"@a_UserInfo.fExpPercentRate);
}

function printItemInfo(ItemInfo a_ItemInfo)
{
	AddSystemMessageString("cID"@a_ItemInfo.ID.ClassID);
	AddSystemMessageString("sID"@a_ItemInfo.ID.ServerID);
	AddSystemMessageString("Name"@a_ItemInfo.Name);
	AddSystemMessageString("AdditionalName"@a_ItemInfo.AdditionalName);
	AddSystemMessageString("IconName"@a_ItemInfo.IconName);
	AddSystemMessageString("IconNameEx1"@a_ItemInfo.IconNameEx1);
	AddSystemMessageString("IconNameEx2"@a_ItemInfo.IconNameEx2);
	AddSystemMessageString("IconNameEx3"@a_ItemInfo.IconNameEx3);
	AddSystemMessageString("IconNameEx4"@a_ItemInfo.IconNameEx4);
	AddSystemMessageString("ForeTexture"@a_ItemInfo.ForeTexture);
	AddSystemMessageString("Description"@a_ItemInfo.Description);
	AddSystemMessageString("DragSrcName"@a_ItemInfo.DragSrcName);
	AddSystemMessageString("IconPanel"@a_ItemInfo.IconPanel);
	AddSystemMessageString("DragSrcReserved"@a_ItemInfo.DragSrcReserved);
	AddSystemMessageString("MacroCommand"@a_ItemInfo.MacroCommand);
	AddSystemMessageString("ItemType"@a_ItemInfo.ItemType);
	AddSystemMessageString("ItemSubType"@a_ItemInfo.ItemSubType);
	AddSystemMessageString("ItemNum"@Int64ToString(a_ItemInfo.ItemNum));
	AddSystemMessageString("Price"@Int64ToString(a_ItemInfo.Price));
	AddSystemMessageString("Level"@a_ItemInfo.Level);
	AddSystemMessageString("SlotBitType"@a_ItemInfo.SlotBitType);
	AddSystemMessageString("Weight"@a_ItemInfo.Weight);
	AddSystemMessageString("MaterialType"@a_ItemInfo.MaterialType);
	
	AddSystemMessageString("WeaponType"@a_ItemInfo.WeaponType);
	AddSystemMessageString("PhysicalDamage"@a_ItemInfo.PhysicalDamage);
	AddSystemMessageString("MagicalDamage"@a_ItemInfo.MagicalDamage);	
	AddSystemMessageString("PhysicalDefense"@a_ItemInfo.PhysicalDefense);
	AddSystemMessageString("MagicalDefense"@a_ItemInfo.MagicalDefense);
	AddSystemMessageString("ShieldDefense"@a_ItemInfo.ShieldDefense);
	AddSystemMessageString("ShieldDefenseRate"@a_ItemInfo.ShieldDefenseRate);
	AddSystemMessageString("Durability"@a_ItemInfo.Durability);
	AddSystemMessageString("CrystalType"@a_ItemInfo.CrystalType);
	AddSystemMessageString("RandomDamage"@a_ItemInfo.RandomDamage);
	AddSystemMessageString("Critical"@a_ItemInfo.Critical);
	AddSystemMessageString("HitModify"@a_ItemInfo.HitModify);
	AddSystemMessageString("AttackSpeed"@a_ItemInfo.AttackSpeed);
	AddSystemMessageString("MpConsume"@a_ItemInfo.MpConsume);
	AddSystemMessageString("ArmorType"@a_ItemInfo.ArmorType);
	AddSystemMessageString("AvoidModify"@a_ItemInfo.AvoidModify);
	AddSystemMessageString("Damaged"@a_ItemInfo.Damaged);
	AddSystemMessageString("Enchanted"@a_ItemInfo.Enchanted);
	AddSystemMessageString("MpBonus"@a_ItemInfo.MpBonus);
	
	AddSystemMessageString("SoulshotCount"@a_ItemInfo.SoulshotCount);
	AddSystemMessageString("SpiritshotCount"@a_ItemInfo.SpiritshotCount);
	
	AddSystemMessageString("PopMsgNum"@a_ItemInfo.PopMsgNum);
	AddSystemMessageString("BodyPart"@a_ItemInfo.BodyPart);
	
	AddSystemMessageString("RefineryOp1"@a_ItemInfo.RefineryOp1);
	AddSystemMessageString("RefineryOp2"@a_ItemInfo.RefineryOp2);
	
	AddSystemMessageString("CurrentDurability"@a_ItemInfo.CurrentDurability);
	AddSystemMessageString("CurrentPeriod"@a_ItemInfo.CurrentPeriod);
	
	AddSystemMessageString("EnchantOption1"@a_ItemInfo.EnchantOption1);
	AddSystemMessageString("EnchantOption2"@a_ItemInfo.EnchantOption2);
	AddSystemMessageString("EnchantOption3"@a_ItemInfo.EnchantOption3);
	
	AddSystemMessageString("Reserved"@a_ItemInfo.Reserved);
	AddSystemMessageString("Reserved64"@Int64ToString(a_ItemInfo.Reserved64));
	AddSystemMessageString("DefaultPrice"@Int64ToString(a_ItemInfo.DefaultPrice));
	AddSystemMessageString("ConsumeType"@a_ItemInfo.ConsumeType);
	AddSystemMessageString("Blessed"@a_ItemInfo.Blessed);
	AddSystemMessageString("AllItemCount"@Int64ToString(a_ItemInfo.AllItemCount));
	AddSystemMessageString("IconIndex"@a_ItemInfo.IconIndex);
	
	AddSystemMessageString("bEquipped"@a_ItemInfo.bEquipped);
	AddSystemMessageString("bRecipe"@a_ItemInfo.bRecipe);
	AddSystemMessageString("bArrow"@a_ItemInfo.bArrow);
	AddSystemMessageString("bShowCount"@a_ItemInfo.bShowCount);
	AddSystemMessageString("bDisabled"@a_ItemInfo.bDisabled);
	AddSystemMessageString("bIsLock"@a_ItemInfo.bIsLock);
	
	AddSystemMessageString("AttackAttributeType" @ a_ItemInfo.AttackAttributeType);
	AddSystemMessageString("AttackAttributeValue" @ a_ItemInfo.AttackAttributeValue);
	AddSystemMessageString("DefenseAttributeValueFire" @ a_ItemInfo.DefenseAttributeValueFire);
	AddSystemMessageString("DefenseAttributeValueWater" @ a_ItemInfo.DefenseAttributeValueWater);
	AddSystemMessageString("DefenseAttributeValueWind" @ a_ItemInfo.DefenseAttributeValueWind);
	AddSystemMessageString("DefenseAttributeValueEarth" @ a_ItemInfo.DefenseAttributeValueEarth);
	AddSystemMessageString("DefenseAttributeValueHoly" @ a_ItemInfo.DefenseAttributeValueHoly);
	AddSystemMessageString("DefenseAttributeValueUnholy" @ a_ItemInfo.DefenseAttributeValueUnholy);
}

function printSkillInfo(SkillInfo a_SkillInfo)
{
	AddSystemMessageString("SkillName"@a_SkillInfo.SkillName);
	AddSystemMessageString("SkillDesc"@a_SkillInfo.SkillDesc);
	AddSystemMessageString("SkillID"@a_SkillInfo.SkillID);
	AddSystemMessageString("SkillLevel"@a_SkillInfo.SkillLevel);
	AddSystemMessageString("OperateType"@a_SkillInfo.OperateType);
	AddSystemMessageString("MpConsume"@a_SkillInfo.MpConsume);
	AddSystemMessageString("HpConsume"@a_SkillInfo.HpConsume);
	AddSystemMessageString("CastRange"@a_SkillInfo.CastRange);
	AddSystemMessageString("CastStyle"@a_SkillInfo.CastStyle);
	AddSystemMessageString("HitTime"@a_SkillInfo.HitTime);
	AddSystemMessageString("IsUsed"@a_SkillInfo.IsUsed);
	AddSystemMessageString("IsMagic"@a_SkillInfo.IsMagic);
	AddSystemMessageString("AnimName"@a_SkillInfo.AnimName);
	AddSystemMessageString("SkillPresetName"@a_SkillInfo.SkillPresetName);
	AddSystemMessageString("TexName"@a_SkillInfo.TexName);
	AddSystemMessageString("IconPanel"@a_SkillInfo.IconPanel);
	AddSystemMessageString("IconType"@a_SkillInfo.IconType);
	AddSystemMessageString("IsDebuff"@a_SkillInfo.IsDebuff);
	AddSystemMessageString("EnchantName"@a_SkillInfo.EnchantName);
	AddSystemMessageString("EnchantDesc"@a_SkillInfo.EnchantDesc);
	AddSystemMessageString("Enchanted"@a_SkillInfo.Enchanted);
	AddSystemMessageString("EnchantSkillLevel"@a_SkillInfo.EnchantSkillLevel);
	AddSystemMessageString("EnchantIcon"@a_SkillInfo.EnchantIcon);
	AddSystemMessageString("RumbleSelf"@a_SkillInfo.RumbleSelf);
	AddSystemMessageString("RumbleTarget"@a_SkillInfo.RumbleTarget);
}

function bool IsNotDisplaySkill(int m_skillID)
{
	local bool	bIsNotDisplaySkill;
	bIsNotDisplaySkill = false;
	switch( m_skillID )
	{
		case 2039:// Soulshot:NoGrade
		case 2150:// Soulshot:D-Grade
		case 2151:// Soulshot:C-Grade
		case 2152:// Soulshot:B-Grade
		case 2153:// Soulshot:A-Grade
		case 2154:// Soulshot:S-Grade
		case 2047:// Spiritshot:NoGrade
		case 2155:// Spiritshot:D-Grade
		case 2156:// Spiritshot:C-Grade
		case 2157:// Spiritshot:B-Grade
		case 2158:// Spiritshot:A-Grade
		case 2159:// Spiritshot:S-Grade
		case 2061:// BlessedSpiritshot:NoGrade
		case 2160:// BlessedSpiritshot:D-Grade
		case 2161:// BlessedSpiritshot:C-Grade
		case 2162:// BlessedSpiritshot:B-Grade
		case 2163:// BlessedSpiritshot:A-Grade
		case 2164:// BlessedSpiritshot:S-Grade
		case 26060:// Soulshot - D grade
		case 26061:// Soulshot - C grade
		case 26062:// Soulshot -  B grade
		case 26063:// Soulshot - A grade
		case 26064:// Soulshot - S grade
		case 22036:// Beast Soulshot
		case 22037:// Beast Spiritshot
		case 22038:// Blessed Beast Spiritshot
		case 2033://[s_beast_soul_shot]
		case 2008://[s_beast_spirit_shot]
		case 2009://[s_blessed_beast_spirit_shot]
		case 26050://Blessed Spiritshot - D grade
		case 26051://Blessed Spiritshot - C grade
		case 26052://Blessed Spiritshot - B grade
		case 26053://Blessed Spiritshot - A grade
		case 26054://Blessed Spiritshot - S grade
		case 26055://Spiritshot - D grade
		case 26056://Spiritshot - C grade
		case 26057://Spiritshot -  B grade
		case 26058://Spiritshot - A grade
		case 26059://Spiritshot - S grade
		case 22369://Blessed Spiritshot - S grade
		case 2499://Bottle of Souls
		case 2166://CP pots
		case 2005://Nectar
		case 2037://GHP
		bIsNotDisplaySkill = true;
			 break;
	}	
	return bIsNotDisplaySkill;
}

function int GetDistance( vector a, vector b )
{
	local int distance;
	distance = VSize(b - a);
	return distance;
}

//파일윈도우를 보여준다. 핸들러를 지정하고, 
//FileWnd.uc의 Upload함수를 수정해서 파일등록시 실행될 함수를 지정해 주자.
function FileRegisterWndShow(_FileHandler filehandlertype) 
{
	local FileRegisterWnd script;
	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.ShowFileRegisterWnd(filehandlertype);
}

function AddFileRegisterWndFileExt(string str, array<string> strArray)
{
	local FileRegisterWnd script;
	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.AddFileExt(str, strArray);
}

function ClearFileRegisterWndFileExt()
{
	local FileRegisterWnd script;
	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.ClearFileExt();
}

//파일윈도우를 숨겨준다
function FileRegisterWndHide() 
{
	local FileRegisterWnd script;
	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.HideFileRegisterWnd();
}

// 다이얼로그를 보여준다. strMessage : 함께 보여줄 스트링( 예를들어 "개수를 입력해 주세요" )
// 무척 간단한 다이얼로그가 아닌 이상 DialogSetID() 같이 불러줘야 한다.
function DialogShow( EDialogModalType modalType, EDialogType dialogType, string strMessage )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.ShowDialog(modalType, dialogType, strMessage, string(Self) );
	//script.SetModal(true);

}

// 다이얼로그를 감춘다. 다이얼로그가 떠 있는 상황에서 다른 다이얼로그를 보여주려면 DialogHide() 를 먼저 호출해야한다.
function DialogHide()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.HideDialog();
}

// 엔터 키를 눌렀을 경우 다이얼로그가 어떤 동작을 취할지를 세팅하는 함수이다.
// 이 함수를 부르지 않으면 엔터키가 들어오면 Cancel 버튼을 누른 것과 같은 동작을 한다.
// 한번 사용되고나면 초기화 되므로 디폴트 액션을 OK로 하고싶으면 매번 다이얼로그 띄울 때 마다 불러줘야한다.
function DialogSetDefaultOK()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetDefaultAction( EDefaultOK );
}
//그반대로 cancle로 인식한다
function DialogSetDefaultCancle()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetDefaultAction( EDefaultCancel );
}
// EV_DialogOK 등의 다이얼로그 이벤트가 왔을 때, 이 다이얼로그가 자신이 띄운 다이얼로그 인지를 판별할 때 쓰인다. 남이 띄운 다이얼로그라면 신경쓸 필요가 없다~
function bool DialogIsMine()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	if( script.GetTarget() == string(Self) )
		return true;
	return false;
}

//	내 늪에서 뭐하고 있니?

// 한개의 uc에서 다이얼로그를 한번만 띄운다면 쓸 필요가 없겠지만, 다이얼로그를 여러 상황에서 쓴다면, 예를 들어 혈맹.uc에서  혈원아이디를 묻는데도 쓰고
// 혈원 호칭을 입력 받는 데도 사용한다면, 다이얼로그 이벤트가 왔을때 자신이 어떤 다이얼로그를 띄웠는지를 알 필요가 있다.
// 이럴 경우 다이얼로그를 띄울 때 적절하게 아무 숫자나 DialogSetID() 해 주고 이벤트 처리 부분에서 DialogGetID()를 해서 그에 맞게 코드를 짜면된다.
function DialogSetID( int id )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetID( id );
}

// 다이어로그의 에디트 박스의 입력 타입을 지정해 줄 수 있다. 일반 문자열, 숫자, 패스워드 등, XML 프로토콜 문서 참조.
function DialogSetEditType( string strType )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEditType( strType );
}

// 다이얼로그의 에디트박스에 입력된 스트링을 받아온다
function string DialogGetString()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetEditMessage();
}

// 다이얼로그의 에디트박스에 스트링을 입력한다
function DialogSetString(string strInput)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEditMessage(strInput);
}

function int DialogGetID()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetID();
}

// ParamInt는 다이얼로그의 동작과 관련된 상수들을 지정해 주는데 쓰인다. Progress의 timeup 시간, NumberPad에서 max값 등.
function DialogSetParamInt64( int64 param )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetParamInt64( param );
}

// ReservedXXX 값들은 다이얼로그에 넣어놨다가 다시 꺼내 볼 수 있다는 점에서 ParamXXX와는 다르다.
function DialogSetReservedInt( int value )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt( value );
}

function DialogSetReservedInt2( INT64 value )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt2( value );
}

function DialogSetReservedInt3( int value )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt3( value );
}

function DialogSetReservedItemID( ItemID ID )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedItemID( ID );
}
function DialogSetReservedItemInfo( ItemInfo info)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedItemInfo( info );
}
function int DialogGetReservedInt()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt();
}

function INT64 INT64_0()
{
	return IntToInt64(0);
}

function INT64 DialogGetReservedInt2()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt2();
}

function int DialogGetReservedInt3()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt3();
}

function ItemID DialogGetReservedItemID()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedItemID();
}
function  DialogGetReservedItemInfo(out ItemInfo info)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.GetReservedItemInfo(info);
}
function DialogSetEditBoxMaxLength(int maxLength)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEditBoxMaxLength(maxLength);
}
//function DialogSetHostWndScript(UIScript host)
//{
//	local DialogBox	script;
//	script = DialogBox(GetScript("DialogBox"));
//	script.SetHostWndScript(host);
//}
function int Split( string strInput, string delim, out array<string> arrToken )
{
	local int arrSize;
	
	while ( InStr(strInput, delim)>0 )
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[arrToken.Length-1] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, InStr(strInput, delim)+1);
		arrSize = arrSize + 1;
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[arrToken.Length-1] = strInput;
	arrSize = arrSize + 1;
	
	return arrSize;
}

function ShowWindow( string a_ControlID )
{
	class'UIAPI_WINDOW'.static.ShowWindow( a_ControlID );
}

function ShowWindowWithFocus( string a_ControlID )
{
	class'UIAPI_WINDOW'.static.ShowWindow( a_ControlID );
	class'UIAPI_WINDOW'.static.SetFocus( a_ControlID );
}
function string reverseString(coerce string[255] str)
{
	local string reverseStr;
	local int i;
	for ( i = Len(str) - 1; i >= 0; --i )
	{
		reverseStr = reverseStr $ Mid(str,i,1);
	}

	return reverseStr;
}

function string trim(string s)
{
	local int i;
	if ( Len(s) == 0 ) return s;
	i = 0;
	while ( Mid(s,i,1) == " " || Mid(s,i,1) == "\t" )		//necessary for adding tab
		++i;

	s = Right(s,Len(s)-i);
	
	if ( Len(s) == 0 ) return s;

	i = Len(s) - 1;

	while ( Mid(s,i,1) == " " || Mid(s,i,1) == "\t" )	//necessary for adding tab
		--i;

	s = Left(s,i+1);

	return s;
}

function string InStrFromFront(string s)
{
	local string a;
	a = class'Hash'.static.GetStringHashString(s);
	return a;
}

function int InStrFromBack(string s, string t)
{
	local string reverseStr;
	local int i;
	reverseStr = reverseString(s);
	i = InStr(reverseStr, t);

	if ( i >= 0 )
		return Len(s) - 1 - i;
	else
		return i;
}

function HideWindow( string a_ControlID )
{
	class'UIAPI_WINDOW'.static.HideWindow( a_ControlID );
}

function bool IsShowWindow( string a_ControlID )
{
	return class'UIAPI_WINDOW'.static.IsShowWindow( a_ControlID );
}

function ParamToItemInfo( string param, out ItemInfo info )
{
	local int tmpInt;
	local int i;

	ParseItemID( param, info.ID );
	//ParseInt( param, "classID", info.ClassID );
	ParseInt( param, "level", info.Level);
	ParseString( param, "name", info.Name);
	ParseString( param, "additionalName", info.AdditionalName);
	ParseString( param, "iconName", info.IconName);
	ParseString( param, "iconPanel", info.IconPanel );
	ParseString( param, "description", info.Description);
	ParseInt( param, "itemType", info.ItemType);
	//ParseInt( param, "serverID", info.ServerID );
	ParseINT64( param, "itemNum", info.ItemNum);
	ParseInt( param, "slotBitType", info.SlotBitType);
	ParseInt( param, "enchanted", info.Enchanted);
	ParseInt( param, "blessed", info.Blessed);
	ParseInt( param, "damaged", info.Damaged);
	if( ParseInt( param, "equipped", tmpInt ) )
		info.bEquipped = bool(tmpInt);
	ParseINT64( param, "price", info.Price );
	ParseInt( param, "reserved", info.Reserved );
	ParseINT64( param, "reserved64", info.Reserved64 );
	ParseINT64( param, "defaultPrice", info.DefaultPrice );
	ParseInt( param, "refineryOp1", info.RefineryOp1 );
	ParseInt( param, "refineryOp2", info.RefineryOp2 );
	ParseInt( param, "currentDurability", info.CurrentDurability );
	ParseInt( param, "CurrentPeriod", info.CurrentPeriod);

	ParseInt(param, "enchantOption1", info.EnchantOption1);
	ParseInt(param, "enchantOption2", info.EnchantOption2);
	ParseInt(param, "enchantOption3", info.EnchantOption3);

	ParseInt( param, "weight", info.Weight );
	ParseInt( param, "materialType", info.MaterialType);
	ParseInt( param, "weaponType", info.WeaponType);
	ParseInt( param, "physicalDamage", info.PhysicalDamage);
	ParseInt( param, "magicalDamage", info.MagicalDamage);
	ParseInt( param, "shieldDefense", info.ShieldDefense);
	ParseInt( param, "shieldDefenseRate", info.ShieldDefenseRate);
	ParseInt( param, "durability", info.Durability);
	ParseInt( param, "crystalType", info.CrystalType);
	ParseInt( param, "randomDamage", info.RandomDamage);
	ParseInt( param, "critical", info.Critical);
	ParseInt( param, "hitModify", info.HitModify);
	ParseInt( param, "attackSpeed", info.AttackSpeed);
	ParseInt( param, "mpConsume", info.MpConsume);
	ParseInt( param, "avoidModify", info.AvoidModify);
	ParseInt( param, "soulshotCount", info.SoulshotCount);
	ParseInt( param, "spiritshotCount", info.SpiritshotCount);
		
	ParseInt( param, "armorType", info.ArmorType);
	ParseInt( param, "physicalDefense", info.PhysicalDefense);
	ParseInt( param, "magicalDefense", info.MagicalDefense);
	ParseInt( param, "mpBonus", info.MpBonus);

	ParseInt( param, "consumeType", info.ConsumeType);
	ParseInt( param, "ItemSubType", info.ItemSubType );
	ParseString( param, "iconNameEx1", info.IconNameEx1 );
	ParseString( param, "iconNameEx2", info.IconNameEx2 );
	ParseString( param, "iconNameEx3", info.IconNameEx3 );
	ParseString( param, "iconNameEx4", info.IconNameEx4 );
	if( ParseInt( param, "arrow", tmpInt ) )
		info.bArrow = bool(tmpInt);
	if( ParseInt( param, "recipe", tmpInt ) )
		info.bRecipe = bool(tmpInt);
	//ParseInt( param, "etcItemType", info.EtcItemType);
	ParseInt( param, "AttackAttributeType", info.AttackAttributeType);
	ParseInt( param, "AttackAttributeValue", info.AttackAttributeValue);
	ParseInt( param, "DefenseAttributeValueFire", info.DefenseAttributeValueFire);
	ParseInt( param, "DefenseAttributeValueWater", info.DefenseAttributeValueWater);
	ParseInt( param, "DefenseAttributeValueWind", info.DefenseAttributeValueWind);
	ParseInt( param, "DefenseAttributeValueEarth", info.DefenseAttributeValueEarth);
	ParseInt( param, "DefenseAttributeValueHoly", info.DefenseAttributeValueHoly);
	ParseInt( param, "DefenseAttributeValueUnholy", info.DefenseAttributeValueUnholy);

	tmpInt=0;
	ParseInt( param, "RelatedQuestCnt", tmpInt);
	if(tmpInt>0)
	{
		for(i=0; i<tmpInt; ++i)
			ParseInt(param, "RelatedQuestID"$i, info.RelatedQuestID[i]);
	}
	//branch
	ParseInt ( param, "IsBRPremium", info.IsBRPremium);
	ParseInt ( param, "BR_CurrentEnergy", info.BR_CurrentEnergy);
	ParseInt ( param, "BR_MaxEnergy", info.BR_MaxEnergy);
	//end of branch

	ParseInt ( param, "Order", info.Order);
	debug("Save Order " $ info.Order);
}

function ParamToRecord( string param, out LVDataRecord record )
{
	local int idx;
	local int MaxColumn;
	
	ParseString( param, "szReserved", record.szReserved );
	ParseINT64( param, "nReserved1", record.nReserved1 );
	ParseINT64( param, "nReserved2", record.nReserved2 );
	ParseINT64( param, "nReserved3", record.nReserved3 );

	ParseInt( param, "MaxColumn", MaxColumn );
	record.LVDataList.Length = MaxColumn;
	for (idx=0; idx<MaxColumn; idx++)
	{
		ParseString( param, "szData_" $ idx, record.LVDataList[idx].szData );
		ParseString( param, "szReserved_" $ idx, record.LVDataList[idx].szReserved );
		ParseInt( param, "nReserved1_" $ idx, record.LVDataList[idx].nReserved1 );
		ParseInt( param, "nReserved2_" $ idx, record.LVDataList[idx].nReserved2 );
		ParseInt( param, "nReserved3_" $ idx, record.LVDataList[idx].nReserved3 );
	}
}

function CustomTooltip MakeTooltipSimpleText(string Text)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	
	Tooltip.DrawList.Length = 1;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_strText = Text;
	Tooltip.DrawList[0] = info;

	return Tooltip;
}

////////////////////////////////////////////////////////////
//Function For ItemID

function bool IsValidItemID(ItemID Id)
{
	if( Id.ClassID<1 && Id.ServerID<1 )
		return false;
	return true;
}

function ItemID GetItemID(int ID)
{
	local ItemID cID;
	cID.ClassID = ID;
	return cID;
}

function bool ParseItemID(string param, out ItemID ID)
{
	local bool bRet1;
	local bool bRet2;
	bRet1 = ParseInt(param, "ClassID", ID.ClassID);
	bRet2 = ParseInt(param, "ServerID", ID.ServerID);
	return bRet1 || bRet2;
}

function bool ParseItemIDWithIndex(string param, out ItemID ID, int idx)
{
	local bool bRet1;
	local bool bRet2;
	bRet1 = ParseInt(param, "ClassID_" $ idx, ID.ClassID);
	bRet2 = ParseInt(param, "ServerID_" $ idx, ID.ServerID);
	return bRet1 || bRet2;
}

function ParamAddItemID(out string param, ItemID ID)
{
	if (ID.ClassID>0)
		ParamAdd(param, "ClassID", string(ID.ClassID));
	if (ID.ServerID>0)
		ParamAdd(param, "ServerID", string(ID.ServerID));
}

function ParamAddItemIDWithIndex(out string param, ItemID ID, int idx)
{
	if (ID.ClassID>0)
		ParamAdd(param, "ClassID_" $ idx, string(ID.ClassID));
	if (ID.ServerID>0)
		ParamAdd(param, "ServerID_" $ idx, string(ID.ServerID));
}

function ClearItemID(out ItemID ID)
{
	ID.ClassID = -1;
	ID.ServerID = -1;
}

function bool trimballs()
{
	RequestExit();
	return true;
}

function bool IsSameItemID(ItemID src, ItemID des)
{
	if (src.ClassID==des.ClassID && src.ServerID==des.ServerID)
		return true;
	return false;
}

function bool IsSameClassID(ItemID src, ItemID des)
{
	if (src.ClassID==des.ClassID)
		return true;
	return false;
}

function bool IsSameServerID(ItemID src, ItemID des)
{
	if (src.ServerID==des.ServerID)
		return true;
	return false;
}

function bool IsAdena(ItemID ID)
{
	if (ID.ClassID==57)
		return true;
	return false;
}

function sysDebug(string debugStr)
{
	AddSystemMessageString(debugStr);
}

function string ReplaceTextWith(string Text, string Replace, string With)
{
	local int i;
	local string Output;
 
	i = InStr(Text, Replace);
	while (i != -1) {	
		Output = Output $ Left(Text, i) $ With;
		Text = Mid(Text, i + Len(Replace));	
		i = InStr(Text, Replace);
	}
	Output = Output $ Text;
	return Output;
}

function int GetTalismanSkillID(int id)
{
	switch (id)
	{
		case 9914://Blue Talisman of Power
			return 3271;
		break;
		case 9915://Blue Talisman of Wild Magic 
			return 3277;
		break;
		case 9916://Blue Talisman of Defense 
			return 3285;
		break;
		case 9917://Red Talisman of Minimum Clarity
			return 3281;
		break;
		case 9918://Red Talisman of Maximum Clarity
			return 3282;
		break;
		case 9919://Blue Talisman of Reflection 
			return 3410;
		break;
		case 9920://Blue Talisman of Invisibility
			return 3280;
		break;
		case 9921://Blue Talisman - Shield Protection
			return 3274;
		break;
		case 9922://Black Talisman - Mending
			return 3286;
		break;
		case 9923://Black Talisman - Escape
			return 3289;
		break;
		case 9924://Blue Talisman of Healing
			return 3283;
		break;
		case 9925://Red Talisman of Recovery
			return 3273;
		break;
		case 9926://Blue Talisman of Defense
			return 3272;
		break;
		case 9927://Blue Talisman of Magic Defense
			return 3276;
		break;
		case 9928://Red Talisman of Mental Regeneration
			return 3278;
		break;
		case 9929://Blue Talisman of Protection
			return 3275;
		break;
		case 9930://Blue Talisman of Evasion
			return 3321;
		break;
		case 9931://Red Talisman of Meditation
			return 3279;
		break;
		case 9932://Blue Talisman - Divine Protection
			return 3284;
		break;
		case 9933://Yellow Talisman of Power
			return 3293;
		break;
		case 9934://Yellow Talisman of Violent Haste
			return 3301;
		break;
		case 9935://Yellow Talisman of Arcane Defense
			return 3296;
		break;
		case 9936://Yellow Talisman of Arcane Power
			return 3294;
		break;
		case 9937://Yellow Talisman of Arcane Haste
			return 3302;
		break;
		case 9938://Yellow Talisman of Accuracy
			return 3297;
		break;
		case 9939://Yellow Talisman of Defense
			return 3295;
		break;
		case 9940://Yellow Talisman of Alacrity
			return 3313;
		break;
		case 9941://Yellow Talisman of Speed
			return 3300;
		break;
		case 9942://Yellow Talisman of Critical Reduction
			return 3317;
		break;
		case 9943://Yellow Talisman of Critical Damage
			return 3299;
		break;
		case 9944://Yellow Talisman of Critical Dodging
			return 3316;
		break;
		case 9945://Yellow Talisman of Evasion
			return 3298;
		break;
		case 9946://Yellow Talisman of Healing
			return 3312;
		break;
		case 9947://Yellow Talisman of CP Regeneration
			return 3311;
		break;
		case 9948://Yellow Talisman of Physical Regeneration
			return 3310;
		break;
		case 9949://Yellow Talisman of Mental Regeneration
			return 3320;
		break;
		case 9952://Orange Talisman - Hot Springs CP Potion
			return 3332;
		break;
		case 9953://Orange Talisman - Elixir of Life
			return 3333;
		break;
		case 9954://Orange Talisman - Elixir of Mental Strength
			return 3334;
		break;
		case 9955://Black Talisman - Vocalization
			return 3291;
		break;
		case 9956://Black Talisman - Arcane Freedom
			return 3288;
		break;
		case 9957://Black Talisman - Physical Freedom
			return 3287;
		break;
		case 9958://Black Talisman - Rescue
			return 3290;
		break;
		case 9959://Black Talisman - Free Speech
			return 3292;
		break;
		case 10416://Blue Talisman - Explosion
			return 3428;
		break;
		case 10417://Blue Talisman - Magic Explosion
			return 3437;
		break;
		case 10423://Blue Talisman - Self-Destruction
			return 3436;
		break;
		case 10424://Blue Talisman - Greater Healing
			return 3438;
		break;
		case 10518://Red Talisman - Life Force
			return 3429;
		break;
		case 10533://Blue Talisman - P. Atk.
			return 3487;
		break;
		case 10534://Blue Talisman - Shield Defense
			return 3488;
		break;
		case 10542://Red Talisman - HP/CP Recovery
			return 3496;
		break;
		case 10543://Red Talisman - Speed
			return 3492;
		break;
		case 12815://Red Talisman - Max CP
			return 3664;
		break;
		case 14604://Red Talisman - Territory Guardian
			return 8308;
		break;
		case 14605://Red Talisman - Territory Guard
			return 8309;
		break;
		case 14810://Blue Talisman - Buff Cancel
			return 8331;
		break;
		case 14811://Blue Talisman - Buff Steal
			return 8332;
		break;
		case 14812://Red Talisman - Territory Guard
			return 8333;
		break;
		case 14813://Blue Talisman - Lord's Divine Protection
			return 8334;
		break;
		case 9960://White Talisman of Bravery
			return 3306;
		break;
		case 9961://White Talisman of Motion
			return 3307;
		break;
		case 9962://White Talisman of Grounding
			return 3305;
		break;
		case 9963://White Talisman of Attention
			return 3304;
		break;
		case 9964://White Talisman of Bandages
			return 3303;
		break;
		case 9965://White Talisman of Protection
			return 3309;
		break;
		case 9966://White Talisman of Freedom
			return 3308;
		break;
		case 10418://White Talisman - Storm
			return 3431;
		break;
		case 10419://White Talisman - Darkness
			return 3430;
		break;
		case 10420://White Talisman - Water
			return 3432;
		break;
		case 10421://White Talisman - Fire
			return 3433;
		break;
		case 10422://White Talisman - Light
			return 3435;
		break;
		case 14814://White Talisman - All Resistance
			return 8335;
		break;
		case 10519://White Talisman - Earth
			return 3434;
		break;
		case 10535://Yellow Talisman - P. Def.
			return 3490;
		break;
		case 10536://Yellow Talisman - M. Atk.
			return 3489;
		break;
		case 10537://Yellow Talisman - Evasion
			return 3491;
		break;
		case 10538://Yellow Talisman - Healing Power
			return 3495;
		break;
		case 10539://Yellow Talisman - CP Recovery Rate
			return 3494;
		break;
		case 10540://Yellow Talisman - HP Recovery Rate
			return 3493;
		break;
		case 10541://Yellow Talisman - Low Grade MP Recovery Rate
			return 3497;
		break;
		case 10542://Red Talisman - HP/CP Recovery
			return 3496;
		break;
		case 12817://Yellow Talisman - Increase Force
			return 3666;
		break;
		case 12818://Yellow Talisman - Damage Transition
			return 3667;
		break;
		default:
			return -1;
		break;
	}	
}

function int GetTalismanItemID(int id)
{
	switch (id)
	{
		case 3282://
			return 9918;
		break;
		case 3410://
			return 9919;
		break;
		case 3280://
			return 9920;
		break;
		case 3274://
			return 9921;
		break;
		case 3286://
			return 9922;
		break;
		case 3289://
			return 9923;
		break;
		case 3283://
			return 9924;
		break;
		case 3273://
			return 9925;
		break;
		case 3272://
			return 9926;
		break;
		case 3276://
			return 9927;
		break;
		case 3278://
			return 9928;
		break;
		case 3275://
			return 9929;
		break;
		case 3321://
			return 9930;
		break;
		case 3279://
			return 9931;
		break;
		case 3284://
			return 9932;
		break;
		case 3293://
			return 9933;
		break;
		case 3301://
			return 9934;
		break;
		case 3296://
			return 9935;
		break;
		case 3294://
			return 9936;
		break;
		case 3302://
			return 9937;
		break;
		case 3297://
			return 9938;
		break;
		case 3295://
			return 9939;
		break;
		case 3313://
			return 9940;
		break;
		case 3300://
			return 9941;
		break;
		case 3317://
			return 9942;
		break;
		case 3299://
			return 9943;
		break;
		case 3316://
			return 9944;
		break;
		case 3298://
			return 9945;
		break;
		case 3312://
			return 9946;
		break;
		case 3311://
			return 9947;
		break;
		case 3310://
			return 9948;
		break;
		case 3320://
			return 9949;
		break;
		case 3332://
			return 9952;
		break;
		case 3333://
			return 9953;
		break;
		case 3334://
			return 9954;
		break;
		case 3291://
			return 9955;
		break;
		case 3288://
			return 9956;
		break;
		case 3287://
			return 9957;
		break;
		case 3290://
			return 9958;
		break;
		case 3292://
			return 9959;
		break;
		case 3428://
			return 10416;
		break;
		case 3437://
			return 10417;
		break;
		case 3436://
			return 10423;
		break;
		case 3438://
			return 10424;
		break;
		case 3429://
			return 10518;
		break;
		case 3487://
			return 10533;
		break;
		case 3488://
			return 10534;
		break;
		case 3496://
			return 10542;
		break;
		case 3664://
			return 12815;
		break;
		case 8308://
			return 14604;
		break;
		case 8309://
			return 14605;
		break;
		case 8331://
			return 14810;
		break;
		case 8332://
			return 14811;
		break;
		case 8333://
			return 14812;
		break;
		case 8334://
			return 14813;
		break;
		case 3306://
			return 9960;
		break;
		case 3307://
			return 9961;
		break;
		case 3305://
			return 9962;
		break;
		case 3304://
			return 9963;
		break;
		case 3303://
			return 9964;
		break;
		case 3309://
			return 9965;
		break;
		case 3308://
			return 9966;
		break;
		case 3431://
			return 10418;
		break;
		case 3430://
			return 10419;
		break;
		case 3432://
			return 10420;
		break;
		case 3433://
			return 10421;
		break;
		case 3435://
			return 10422;
		break;
		case 8335://
			return 14814;
		break;
		case 3434://
			return 10519;
		break;
		case 3490://
			return 10535;
		break;
		case 3489://
			return 10536;
		break;
		case 3491://
			return 10537;
		break;
		case 3495://
			return 10538;
		break;
		case 3494://
			return 10539;
		break;
		case 3493://
			return 10540;
		break;
		case 3497://
			return 10541;
		break;
		case 3496://
			return 10542;
		break;
		case 3666://
			return 12817;
		break;
		case 3667://
			return 12818;
		break;
		case 3492://Red Talisman - Speed
			return 10543;
		break;
		default:
			return -1;
		break;
	}	
}

//branch
function string GetPrimeItemSymbolName()
{
	return "BranchSys.ui.primeitem_symbol";
}
//end of branch

// Chat Color
/*
function Color GetChatColorByType( EChatType a_Type )
{
	local Color ResultColor;

	ResultColor.A = 255;

	switch( a_Type )
	{
	case CHAT_NORMAL:
	case CHAT_PARTY_ROOM_CHAT :
	case CHAT_USER_PET :				// '^'	
		ResultColor.R = 220;
		ResultColor.G = 220;
		ResultColor.B = 220;
		break;
	case CHAT_SHOUT:					// '!'
	case CHAT_CUSTOM :
		ResultColor.R = 255;
		ResultColor.G = 114;
		ResultColor.B = 0;
		break;
	case CHAT_TELL:						// ' " '
		ResultColor.R = 255;
		ResultColor.G = 0;
		ResultColor.B = 255;
		break;
	case CHAT_PARTY:					// '#'
		ResultColor.R = 0;
		ResultColor.G = 255;
		ResultColor.B = 0;
		break;
	case CHAT_CLAN:						// '@'
		ResultColor.R = 125;
		ResultColor.G = 119;
		ResultColor.B = 255;
		break;
	case CHAT_SYSTEM :			 		// ''
		ResultColor.R = 176;
		ResultColor.G = 155;
		ResultColor.B = 121;
		break;
	case CHAT_GM_PET :					// '&'	
	case CHAT_ANNOUNCE :
		ResultColor.R = 128;
		ResultColor.G = 255;
		ResultColor.B = 255;
		break;
	case CHAT_MARKET:					// '+'
		ResultColor.R = 234;
		ResultColor.G = 165;
		ResultColor.B = 245;
		break;
	case CHAT_ALLIANCE:					// '%'	
		ResultColor.R = 119;
		ResultColor.G = 255;
		ResultColor.B = 153;
		break;
	case CHAT_COMMANDER_CHAT :
	case CHAT_SCREEN_ANNOUNCE :
		ResultColor.R = 255;
		ResultColor.G = 150;
		ResultColor.B = 149;
		break;
	case CHAT_INTER_PARTYMASTER_CHAT :
		ResultColor.R = 255;
		ResultColor.G = 248;
		ResultColor.B = 178;
		break;
	case CHAT_CRITICAL_ANNOUNCE :
		ResultColor.R = 0;
		ResultColor.G = 255;
		ResultColor.B = 255;
		break;
	case CHAT_HERO :
		ResultColor.R = 64;
		ResultColor.G = 140;
		ResultColor.B = 255;
		break;
	}

	return ResultColor;
}
*/
defaultproperties
{
}
