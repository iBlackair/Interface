class CharacterCreateMenuWnd extends UICommonAPI;


const RT_HUMAN	= 0;
const RT_ELF	= 1; 
const RT_DARKELF= 2; 
const RT_ORC	= 3;	 
const RT_DWARF	= 4;
const RT_KAMAEL	= 5;
const MAX_RACE=6;

var string RACE_STR[MAX_RACE];

const MAX_JOB=2;
var string JOB_STR[MAX_JOB];

const MAX_SEX=2;
var string SEX_STR[MAX_SEX];


// default armor
const ST_GLOVES	= 0;
const ST_CHEST  = 1;
const ST_LEGS	= 2;
const ST_FEET	= 3;
const ST_MAX	= 4;

// default character
const Human_Knight_M=0;
const Human_Knight_F=1;
const Human_Mage_M=2;
const Human_Mage_F=3;

const Elf_Knight_M=4;
const Elf_Knight_F=5;
const Elf_Mage_M=6;
const Elf_Mage_F=7;

const DarkElf_Knight_M=8;
const DarkElf_Knight_F=9;
const DarkElf_Mage_M=10;
const DarkElf_Mage_F=11;

const Orc_Knight_M=12;
const Orc_Knight_F=13;
const Orc_Mage_M=14;
const Orc_Mage_F=15;

const Dwarf_Knight_M=16;
const Dwarf_Knight_F=17;

const Kamael_Soldier_M=18;
const Kamael_Soldier_F=19;
const MAX_CHARACTER=20;

struct CharArmor
{
	var int Armor[ST_MAX];
};

var CharArmor m_Char[MAX_CHARACTER];


// For FunctionWnd
var WindowHandle	m_hBtnRequestCreateCharacter;
var WindowHandle	m_hBtnPrev;

// For Class description
var TextBoxHandle	m_hTbClassDescription;

// ForSetupWnd
var EditBoxHandle	m_hEbName;
var ComboBoxHandle	m_hCbRace;
var ComboBoxHandle	m_hCbJob;
var ComboBoxHandle	m_hCbSex;
var ComboBoxHandle	m_hCbHairType;
var ComboBoxHandle	m_hCbHairColor;
var ComboBoxHandle	m_hCbFaceType;


var ButtonHandle	m_hBtnRotateLeft;
var ButtonHandle	m_hBtnRotateRight;
var ButtonHandle	m_hBtnZoomIn;
var ButtonHandle	m_hBtnZoomOut;



var int m_CameraState;
var bool m_bZoomed;

function OnRegisterEvent()
{
	RegisterEvent(EV_CharacterCreateSetClassDesc);
	RegisterEvent(EV_CharacterCreateClearClassDesc);
	RegisterEvent(EV_CharacterCreateClearSetupWnd);
	RegisterEvent(EV_CharacterCreateClearWnd);
	RegisterEvent(EV_CharacterCreateClearName);
	RegisterEvent( EV_CharacterCreateEnableRotate);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hBtnRequestCreateCharacter=(GetHandle("CharacterCreateMenuWnd.CharacterCreateFunctionWnd.btnRequestCreateCharacter"));
		m_hBtnPrev=(GetHandle("CharacterCreateMenuWnd.CharacterCreateFunctionWnd.btnPrev"));

		m_hTbClassDescription=TextBoxHandle(GetHandle("CharacterCreateMenuWnd.CharacterCreateClassInfoWnd.txtVarClassDescription"));

		m_hEbName=EditBoxHandle(GetHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.ebName"));
		m_hCbRace=ComboBoxHandle(GetHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbRace"));	
		m_hCbJob=ComboBoxHandle(GetHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbJob"));	
		m_hCbSex=ComboBoxHandle(GetHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbSex"));		
		m_hCbHairType=ComboBoxHandle(GetHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbHairType"));		
		m_hCbHairColor=ComboBoxHandle(GetHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbHairColor"));
		m_hCbFaceType=ComboBoxHandle(GetHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbFaceType"));

		m_hBtnRotateLeft=ButtonHandle(GetHandle("CharacterCreateMenuWnd.btnRotateLeft"));
		m_hBtnRotateRight=ButtonHandle(GetHandle("CharacterCreateMenuWnd.btnRotateRight"));
		m_hBtnZoomIn=ButtonHandle(GetHandle("CharacterCreateMenuWnd.btnZoomIn"));
		m_hBtnZoomOut=ButtonHandle(GetHandle("CharacterCreateMenuWnd.btnZoomOut"));
	}
	else
	{
		m_hBtnRequestCreateCharacter=GetButtonHandle("CharacterCreateMenuWnd.CharacterCreateFunctionWnd.btnRequestCreateCharacter");
		m_hBtnPrev=GetButtonHandle("CharacterCreateMenuWnd.CharacterCreateFunctionWnd.btnPrev");

		m_hTbClassDescription=GetTextBoxHandle("CharacterCreateMenuWnd.CharacterCreateClassInfoWnd.txtVarClassDescription");

		m_hEbName=GetEditBoxHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.ebName");
		m_hCbRace=GetComboBoxHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbRace");	
		m_hCbJob=GetComboBoxHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbJob");	
		m_hCbSex=GetComboBoxHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbSex");		
		m_hCbHairType=GetComboBoxHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbHairType");		
		m_hCbHairColor=GetComboBoxHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbHairColor");
		m_hCbFaceType=GetComboBoxHandle("CharacterCreateMenuWnd.CharacterCreateSetupWnd.cbFaceType");

		m_hBtnRotateLeft=GetButtonHandle("CharacterCreateMenuWnd.btnRotateLeft");
		m_hBtnRotateRight=GetButtonHandle("CharacterCreateMenuWnd.btnRotateRight");
		m_hBtnZoomIn=GetButtonHandle("CharacterCreateMenuWnd.btnZoomIn");
		m_hBtnZoomOut=GetButtonHandle("CharacterCreateMenuWnd.btnZoomOut");
	}

	m_hBtnRotateLeft.HideWindow();
	m_hBtnRotateRight.HideWindow();
	m_hBtnZoomIn.HideWindow();
	m_hBtnZoomOut.HideWindow();

	m_CameraState=0;
	m_bZoomed=false;

	InitString();
}

function InitString()
{
	// Race string
	RACE_STR[0]="HUMAN";
	RACE_STR[1]="ELF";
	RACE_STR[2]="DARKELF";
	RACE_STR[3]="ORC";
	RACE_STR[4]="DWARF";
	//������-solasys
	RACE_STR[5]="KAMAEL";

	// Job string
	JOB_STR[0]="KNIGHT";
	JOB_STR[1]="WIZARD";

	// Sex string
	SEX_STR[0]="MAN";
	SEX_STR[1]="WOMAN";
}

function OnShow()
{
	m_hEbName.SetFocus();
}

function OnClickButton(string strID)
{
	switch(strID)
	{
	case "btnRequestCreateCharacter" :
//		debug("string:"$m_hEbName.GetString()$", ����:"$Len(m_hEbName.GetString()));
		HandleBtnCreateCharacter();
		break;
	case "btnPrev" :
		RequestPrevState();
		break;
	case "btnZoomIn" :
	case "btnZoomOut" :
		HandleZoom();
		break;
	}
}

function HandleBtnCreateCharacter()
{
	local string Name;
	local int Race;
	local int Job;
	local int Sex;
	local int HairType;
	local int HairColor;
	local int FaceType;
	local int classID;

	Name=m_hEbName.GetString();

	Race=m_hCbRace.GetSelectedNum();
	Job=m_hCbJob.GetSelectedNum();
	Sex=m_hCbSex.GetSelectedNum();

	HairType=m_hCbHairType.GetSelectedNum();
	HairColor=m_hCbHairColor.GetSelectedNum();
	FaceType=m_hCbFaceType.GetSelectedNum();

	classID=CharacterCreateGetClassType(Race, Job, Sex);

	if(IsValidData())
		RequestCreateCharacter(Name, Race, classID, Sex, HairType, HairColor, FaceType);
}

function bool IsValidData()
{
	local string Name;
	local int Race;
	local int Job;
	local int Sex;
	local int HairType;
	local int classID;

	Name=m_hEbName.GetString();
	Job = m_hCbJob.GetSelectedNum();
	Sex = m_hCbSex.GetSelectedNum();

	// name
	if ( Len(Name) == 0) 
	{
		ShowMessageInLogin(GetSystemMessage(80));
		return false;
	}

	if(!CheckNameLength(Name))
	{
		ShowMessageInLogin(GetSystemMessage(80));
		m_hEbName.SetFocus();
		return false;
	}

	if(!CheckValidName(Name))
	{
		ShowMessageInLogin(GetSystemMessage(204));
		m_hEbName.Clear();
		m_hEbName.SetFocus();
		return false;
	}


	// Race
	Race = m_hCbRace.GetSelectedNum();
	if ( Race < 0 ) 	
	{
		ShowMessageInLogin(GetSystemMessage(81));
		return false; 
	}
	// Job
	classID=CharacterCreateGetClassType(Race, Job, Sex);
	if ( classID < 0 ) 
	{
		ShowMessageInLogin(GetSystemMessage(82));
		return false;
	}
	// Gender
	if ( Sex < 0 ) 
	{
		ShowMessageInLogin(GetSystemMessage(83));
		return false;
	}

	// hair style
	HairType = m_hCbHairType.GetSelectedNum();
	if ( HairType < 0 ) 
	{
		ShowMessageInLogin(GetSystemMessage(91));
		return false;
	}
	return true;
}

function HandleZoom()
{
	local int Race;
	local int Job; 
	local int Gender;
	local string EventName;

	m_bZoomed = !m_bZoomed;

	Race = m_hCbRace.GetSelectedNum();
	Job = m_hCbJob.GetSelectedNum();
	Gender = m_hCbSex.GetSelectedNum();


//	NCString str;

	if(m_bZoomed)
	{
		m_hBtnZoomOut.ShowWindow();
		m_hBtnZoomIn.HideWindow();

		//�� ��		
		if (Race >= 0) 
		{
//			str.Add((TCHAR*)RACE_STR[Race]);
			EventName=RACE_STR[Race];
		}
				
		if (Gender >= 0) 
		{
			if(Job==0) 
			{
//				str.Add(TEXT("_K"));
				EventName=EventName$"_K";
			}
			else if(Job==1) 
			{
//				str.Add(TEXT("_W"));
				EventName=EventName$"_W";
			}
//			str.Add(SEX_STR[Gender]);
//			str.Add(TEXT("_CHEST"));
			EventName=EventName$SEX_STR[Gender];
			EventName=EventName$"_CHEST";
		}

		ExecLobbyEvent(EventName,false);

	}
	else
	{
		m_hBtnZoomOut.HideWindow();
		m_hBtnZoomIn.ShowWindow();

        //�� �ƿ�
		if (Race >= 0) 
		{
			EventName=EventName$RACE_STR[Race];
		}
				
		if (Gender >= 0) 
		{
			if(Job==0) 
			{
				EventName=EventName$"_K";
			}
			else if(Job==1) 
			{
				EventName=EventName$"_W";
			}
			EventName=EventName$SEX_STR[Gender];
			EventName=EventName$"_CHEST";
		}

		ExecLobbyEvent(EventName,true);	
	}

}

function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local int index;
	local int Race;
	local int Job;
	local int Sex;
	local string strID;

	Race = m_hCbRace.GetSelectedNum();
	Job = m_hCbJob.GetSelectedNum();
	Sex = m_hCbSex.GetSelectedNum();

	index=GetDefaultCharacterIndex(Race, Job, Sex);

	strID=a_WindowHandle.GetWindowName();

	switch(strID)
	{
	case "btnRotateLeft" :
		DefaultCharacterTurn(index,2.f);
		break;
	case "btnRotateRight" :
		DefaultCharacterTurn(index,-2.f);
		break;
	}
}

function OnLButtonUp( WindowHandle a_WindowHandle, int X, int Y )
{
	local int index;

	local int Race;
	local int Job;
	local int Sex;

	local string strID;

	Race = m_hCbRace.GetSelectedNum();
	Job = m_hCbJob.GetSelectedNum();
	Sex = m_hCbSex.GetSelectedNum();

	index=GetDefaultCharacterIndex(Race, Job, Sex);
	
	strID=a_WindowHandle.GetWindowName();

	switch(strID)
	{
	case "btnRotateLeft" :
		DefaultCharacterStop(index);
		break;
	case "btnRotateRight" :
		DefaultCharacterStop(index);
		break;
	}

}

function OnEvent(int Event_ID, string a_param)
{
//	debug(string(Event_ID)@a_param);
	switch(Event_ID)
	{
	case EV_CharacterCreateSetClassDesc :
		HandleSetClassDescription(a_param);
		m_hCbRace.SetSelectedNum(0);
		OnRaceSelect(0);
		break;
	case EV_CharacterCreateClearClassDesc :
		m_hTbClassDescription.SetText("");
		break;
	case EV_CharacterCreateClearSetupWnd :
		HandleClearSetupWnd();
		break;
	case EV_CharacterCreateClearWnd :
		HandleClear();
		break;
	case EV_CharacterCreateClearName :
		m_hEbName.Clear();
		m_hEbName.SetFocus();
		break;
	case EV_CharacterCreateEnableRotate :
		HandleEnableRotate(a_param);
		break;
	}
}

function HandleEnableRotate(string a_param)
{
	local int enable;

	ParseInt(a_param, "Enable", enable);

	if(enable==1)
		EnableRotate(true);
	else if(enable==0)
		EnableRotate(false);
}



function HandleClear()
{
	HandleClearSetupWnd();
	m_CameraState=0;
	m_hTbClassDescription.SetText("");
}

function HandleClearSetupWnd()
{
	m_hEbName.Clear();
	
	m_hCbRace.SetSelectedNum(-1);
	m_hCbJob.SetSelectedNum(-1);
	m_hCbSex.SetSelectedNum(-1);
	m_hCbHairType.SetSelectedNum(-1);
	m_hCbHairColor.SetSelectedNum(-1);
	m_hCbFaceType.SetSelectedNum(-1);
	EnableRotate(false);
}




function HandleSetClassDescription(string a_param)
{
	local string desc;

	ParseString(a_param, "Description", desc);
	m_hTbClassDescription.SetText(desc);
}


function OnComboBoxItemSelected( String strID, int index )
{
//	debug(strID);
	switch(strID)
	{
	case "cbRace" :
		OnRaceSelect(index);
		break;
	case "cbJob" :
		OnJobSelect(index);
		break;
	case "cbSex" :
		OnSexSelect(index);
		break;
	case "cbHairType" :
		OnHairType(index);
		break;
	case "cbHairColor" :
		OnHairColor(index);
		break;
	case "cbFaceType" :
		OnFaceType(index);
		break;
	}
}

function OnRaceSelect(int index)
{
	SetDefaultCharacter();

	m_hCbJob.SetSelectedNum(-1);
	m_hCbSex.SetSelectedNum(-1);
	m_hCbHairType.SetSelectedNum(-1);
	m_hCbHairColor.SetSelectedNum(-1);
	m_hCbFaceType.SetSelectedNum(-1);


	// ���� �����ְ�
	m_hCbJob.Clear();
	m_hCbJob.SYS_AddString(175);

	if(index==4 || index==5)
	{
		// ���� ���� ����
	}
	else
	{
		// �����, ī������ �ƴϸ� ������ �����ش�
		m_hCbJob.SYS_AddString(176);
	}

	m_hCbRace.EnableWindow();
	m_hCbJob.EnableWindow();
	m_hCbSex.DisableWindow();
	m_hCbHairType.DisableWindow();
	m_hCbHairColor.DisableWindow();
	m_hCbFaceType.DisableWindow();

	EnableRotate(false);

	m_hTbClassDescription.SetText("");	

	CameraMove(1);

	switch(index)
	{
	case RT_HUMAN :
		processSpawnChar(Human_Knight_M, Human_Mage_F);
		SetCameraChar(1);
		break;
	case RT_ELF :
		processSpawnChar(Elf_Knight_M, Elf_Mage_F);
		SetCameraChar(5);
		break;
	case RT_DARKELF :
		processSpawnChar(DarkElf_Knight_M,DarkElf_Mage_F);
		SetCameraChar(9);
		break;
	case RT_ORC :
		processSpawnChar(Orc_Knight_M, Orc_Mage_F);
		SetCameraChar(13);
		break;
	case RT_DWARF :
		processSpawnChar(Dwarf_Knight_M, Dwarf_Knight_F);
		SetCameraChar(16);
		break;
	case RT_KAMAEL :
		processSpawnChar(Kamael_Soldier_M, Kamael_Soldier_F);
		SetCameraChar(18);
		break;
	}

	ShowAllDefaultCharacter();
}

function processSpawnChar(int StartIdx, int EndIdx)
{
	local int i;
	for(i=StartIdx; i<=EndIdx; ++i)
		SpawnDefaultCharacter(i);
}

function OnJobSelect(int index)
{
	local int Race;
	local int Job;
	local int Gender;
	local int id;

	// set default pawn
	SetDefaultCharacter();

	CameraMove(2);

	m_hCbSex.SetSelectedNum(-1);
	m_hCbHairType.SetSelectedNum(-1);
	m_hCbHairColor.SetSelectedNum(-1);
	m_hCbFaceType.SetSelectedNum(-1);

	Race=m_hCbRace.GetSelectedNum();
	Job=m_hCbJob.GetSelectedNum();
	Gender=m_hCbSex.GetSelectedNum();

	// exception handling
	if ( Race < 0 ) 
	{
		ShowMessageInLogin(GetSystemMessage(81));
		m_hCbJob.SetSelectedNum(-1);
		return;
	}

	// show character information
	id=GetIndex(Race, Job, Gender);

	m_hCbRace.EnableWindow();
	m_hCbJob.EnableWindow();
	m_hCbSex.EnableWindow();
	m_hCbHairType.DisableWindow();
	m_hCbHairColor.DisableWindow();
	m_hCbFaceType.DisableWindow();

	EnableRotate(false);

	if (!(id == 10 || id == 11))
		m_hTbClassDescription.SetText(GetClassDescription(id));

	ShowAllDefaultCharacter();

	//dof ��Ŀ�� ȿ�� - yohan
	Id = GetDefaultCharacterIndex(Race, Job, 0);
	SetCameraChar(Id);
}

function OnSexSelect(int index)
{
	local int Race;
	local int Job;
	local int id;
	local int Sex;
	local int idx;


	// set default pawn
	SetDefaultCharacter();
	EnableRotate(false);



	Race=m_hCbRace.GetSelectedNum();
	Job=m_hCbJob.GetSelectedNum();
	Sex=index;

	//Reset Haircolor Combox
	m_hCbHairColor.Clear();
	m_hCbHairColor.AddString(GetSystemString(179));
	m_hCbHairColor.AddString(GetSystemString(180));
	m_hCbHairColor.AddString(GetSystemString(181));
	m_hCbHairColor.AddString(GetSystemString(182));
	
	// set SelectCtrl string
	// orc
	if (Race == 3 )
	{
		// hair style
		// male
		if ( Sex == 0 )
		{
			m_hCbHairType.Clear();
			m_hCbHairType.AddString(GetSystemString(179));
			m_hCbHairType.AddString(GetSystemString(180));
			m_hCbHairType.AddString(GetSystemString(181));
			m_hCbHairType.AddString(GetSystemString(182));
			m_hCbHairType.AddString(GetSystemString(186));
		}
		// female fighter
		else if ( Sex == 1 && Job == 0 )
		{
			m_hCbHairType.Clear();
			m_hCbHairType.AddString(GetSystemString(179));
			m_hCbHairType.AddString(GetSystemString(180));
			m_hCbHairType.AddString(GetSystemString(181));
			m_hCbHairType.AddString(GetSystemString(182));
			m_hCbHairType.AddString(GetSystemString(186));
			m_hCbHairType.AddString(GetSystemString(187));
			m_hCbHairType.AddString(GetSystemString(803));
		}
		// female shaman
		else if ( index == 1 && Job == 1 )
		{
			m_hCbHairType.Clear();
			m_hCbHairType.AddString(GetSystemString(179));
			m_hCbHairType.AddString(GetSystemString(180));
			m_hCbHairType.AddString(GetSystemString(181));
			m_hCbHairType.AddString(GetSystemString(182));
			m_hCbHairType.AddString(GetSystemString(186));
			m_hCbHairType.AddString(GetSystemString(187));
			m_hCbHairType.AddString(GetSystemString(803));
		}
	}
	// dwarf
	else if ( Race == 4 )
	{
		
		if ( Sex == 0 ) 
		{
			m_hCbHairType.Clear();
			m_hCbHairType.AddString(GetSystemString(179));
			m_hCbHairType.AddString(GetSystemString(180));
			m_hCbHairType.AddString(GetSystemString(181));
			m_hCbHairType.AddString(GetSystemString(182));
			m_hCbHairType.AddString(GetSystemString(186));
		}
		else if ( Sex == 1 )
		{
			m_hCbHairType.Clear();
			m_hCbHairType.AddString(GetSystemString(179));
			m_hCbHairType.AddString(GetSystemString(180));
			m_hCbHairType.AddString(GetSystemString(181));
			m_hCbHairType.AddString(GetSystemString(182));
			m_hCbHairType.AddString(GetSystemString(186));
			m_hCbHairType.AddString(GetSystemString(187));
			m_hCbHairType.AddString(GetSystemString(803));
		}
	}
	//������-solasys
	// Kamael
	else if ( Race == 5 )
	{
		//Set Kamael Haircolor
		m_hCbHairColor.Clear();
		m_hCbHairColor.AddString(GetSystemString(179));
		m_hCbHairColor.AddString(GetSystemString(180));
		m_hCbHairColor.AddString(GetSystemString(181));
				
		if ( Sex == 0 ) 
		{
			m_hCbHairType.Clear();
			m_hCbHairType.AddString(GetSystemString(179));
			m_hCbHairType.AddString(GetSystemString(180));
			m_hCbHairType.AddString(GetSystemString(181));
			m_hCbHairType.AddString(GetSystemString(182));
			m_hCbHairType.AddString(GetSystemString(186));
		}
		else if ( Sex == 1 )
		{
			m_hCbHairType.Clear();
			m_hCbHairType.AddString(GetSystemString(179));
			m_hCbHairType.AddString(GetSystemString(180));
			m_hCbHairType.AddString(GetSystemString(181));
			m_hCbHairType.AddString(GetSystemString(182));
			m_hCbHairType.AddString(GetSystemString(186));
			m_hCbHairType.AddString(GetSystemString(187));
			m_hCbHairType.AddString(GetSystemString(803));
		}
	}
	// human,elf,dark elf
	else
	{
		// male
		if ( Sex == 0 )
		{
			m_hCbHairType.Clear();
			m_hCbHairType.AddString(GetSystemString(179));
			m_hCbHairType.AddString(GetSystemString(180));
			m_hCbHairType.AddString(GetSystemString(181));
			m_hCbHairType.AddString(GetSystemString(182));
			m_hCbHairType.AddString(GetSystemString(186));
		}
		// female
		else if ( Sex == 1 )
		{
			m_hCbHairType.Clear();
			m_hCbHairType.AddString(GetSystemString(179));
			m_hCbHairType.AddString(GetSystemString(180));
			m_hCbHairType.AddString(GetSystemString(181));
			m_hCbHairType.AddString(GetSystemString(182));
			m_hCbHairType.AddString(GetSystemString(186));
			m_hCbHairType.AddString(GetSystemString(187));
			m_hCbHairType.AddString(GetSystemString(803));
		}
	}

	// init combo box
	m_hCbHairType.SetSelectedNum(0);
	m_hCbHairColor.SetSelectedNum(0);
	m_hCbFaceType.SetSelectedNum(0);

	// exception handling
	if ( Race < 0 )
	{
		ShowMessageInLogin(GetSystemMessage(81));
		m_hCbJob.SetSelectedNum(-1);
		m_hCbSex.SetSelectedNum(-1);
		m_hCbHairType.SetSelectedNum(-1);
		m_hCbHairColor.SetSelectedNum(-1);
		m_hCbFaceType.SetSelectedNum(-1);
		
		EnableRotate(false);
		
		return;
	}
	else if ( Job < 0 )
	{
		ShowMessageInLogin(GetSystemMessage(82));
		m_hCbSex.SetSelectedNum(-1);
		m_hCbHairType.SetSelectedNum(-1);
		m_hCbHairColor.SetSelectedNum(-1);
		m_hCbFaceType.SetSelectedNum(-1);

		EnableRotate(false);

		return;
	}

	//������-solasys
	if ( Race == 5)
	{
		if (Sex==0)
			id = 10;
		else
			id = 11;

		m_hTbClassDescription.SetText(GetClassDescription(id));
	}

	m_hCbRace.EnableWindow();
	m_hCbJob.EnableWindow();
	m_hCbSex.EnableWindow();
	m_hCbHairType.EnableWindow();
	m_hCbHairColor.EnableWindow();
	m_hCbFaceType.EnableWindow();

	EnableRotate(true);

	ShowAllDefaultCharacter();
	idx = GetDefaultCharacterIndex(Race, Job, Sex);
	ShowOnlyOneDefaultCharacter(idx);
	
	//dof ��Ŀ�� ȿ�� - yohan
	SetCameraChar(idx);

	CameraMove(3);
}

function OnHairType(int index)
{
	local int Race;
	local int Job;
	local int Sex;
	local int id;
	local int HairType;
	local int HairColor;
	local int FaceType;

	// set default pawn
	SetDefaultCharacter();

	Race=m_hCbRace.GetSelectedNum();
	Job=m_hCbJob.GetSelectedNum();
	Sex=m_hCbSex.GetSelectedNum();

	id=GetDefaultCharacterIndex(Race, Job, Sex);
	HairType=m_hCbHairType.GetSelectedNum();
	HairColor=m_hCbHairColor.GetSelectedNum();
	FaceType=m_hCbFaceType.GetSelectedNum();

	// exception handling
	if ( Race < 0 )
	{
		ErrorInRace();
		return;
	}
	else if ( Job < 0 )
	{
		ErrorInJob();
		return;
	}
	else if ( Sex < 0 ) 
	{
		ErrorInSex();
		return;
	}

	SetCharacterStyle(id, HairType, HairColor, FaceType);
}

function OnHairColor(int index)
{
	local int Race;
	local int Job;
	local int Sex;
	local int id;
	local int HairType;
	local int HairColor;
	local int FaceType;

	// set default pawn
	SetDefaultCharacter();

	Race=m_hCbRace.GetSelectedNum();
	Job=m_hCbJob.GetSelectedNum();
	Sex=m_hCbSex.GetSelectedNum();

	id=GetDefaultCharacterIndex(Race, Job, Sex);
	HairType=m_hCbHairType.GetSelectedNum();
	HairColor=m_hCbHairColor.GetSelectedNum();
	FaceType=m_hCbFaceType.GetSelectedNum();

	// exception handling
	if ( Race < 0 )
	{
		ErrorInRace();
		return;
	}
	else if ( Job < 0 )
	{
		ErrorInJob();
		return;
	}
	else if ( Sex < 0 ) 
	{
		ErrorInSex();
		return;
	}
	else if ( HairType < 0 ) 
	{
		ShowMessageInLogin(GetSystemMessage(91));
		return;
	}

	SetCharacterStyle(id, HairType, HairColor, FaceType);
}


function OnFaceType(int index)
{
	local int Race;
	local int Job;
	local int Sex;
	local int id;
	local int HairType;
	local int HairColor;
	local int FaceType;

	// set default pawn
	SetDefaultCharacter();

	Race=m_hCbRace.GetSelectedNum();
	Job=m_hCbJob.GetSelectedNum();
	Sex=m_hCbSex.GetSelectedNum();

	id=GetDefaultCharacterIndex(Race, Job, Sex);
	HairType=m_hCbHairType.GetSelectedNum();
	HairColor=m_hCbHairColor.GetSelectedNum();
	FaceType=m_hCbFaceType.GetSelectedNum();

	// set default pawn
	SetDefaultCharacter();

	// exception handling
	if ( Race < 0 )
	{
		ErrorInRace();
		return;
	}
	else if ( Job < 0 )
	{
		ErrorInJob();
		return;
	}
	else if ( Sex < 0 ) 
	{
		ErrorInSex();
		return;
	}
	else if ( HairType < 0 ) 
	{
		ShowMessageInLogin(GetSystemMessage(91));
		m_hCbHairColor.SetSelectedNum(-1);
		m_hCbFaceType.SetSelectedNum(-1);
		return;
	}
	else if ( HairColor < 0 ) 
	{
		ShowMessageInLogin(GetSystemMessage(366));
		return;
	}

	SetCharacterStyle(id, HairType, HairColor, FaceType);

	return;

}


function ErrorInRace()
{
	ShowMessageInLogin(GetSystemMessage(81));
	m_hCbJob.SetSelectedNum(-1);
	m_hCbSex.SetSelectedNum(-1);
	m_hCbHairType.SetSelectedNum(-1);
	m_hCbHairColor.SetSelectedNum(-1);
	m_hCbFaceType.SetSelectedNum(-1);
	EnableRotate(false);
}

function ErrorInJob()
{
	ShowMessageInLogin(GetSystemMessage(82));
	m_hCbSex.SetSelectedNum(-1);
	m_hCbHairType.SetSelectedNum(-1);
	m_hCbHairColor.SetSelectedNum(-1);
	m_hCbFaceType.SetSelectedNum(-1);
	EnableRotate(false);
}

function ErrorInSex()
{
	ShowMessageInLogin(GetSystemMessage(83));
	m_hCbHairType.SetSelectedNum(-1);
	m_hCbHairColor.SetSelectedNum(-1);
	m_hCbFaceType.SetSelectedNum(-1);
	EnableRotate(false);
}



function int GetDefaultCharacterIndex(int Race, int Job, int Sex)
{

	//������-solasys
	if (Race == 5)
		return (Race*4 + Job * 2 + Sex - 2);
	else
		return (Race*4 + Job * 2 + Sex);
}




function int GetIndex(int Race, int Job, int Gender)
{
	local int index;

	switch(Race)
	{
	case RT_HUMAN :
		if(Job==0)
			index=1;
		else if(Job==1)
			index=2;
		break;
	case RT_ELF	:
		if(Job==0)
			index=3;
		else if(Job==1)
			index=4;
		break;
	case RT_DARKELF :
		if(Job==0)
			index=5;
		else if(Job==1)
			index=6;
		break;
	case RT_ORC	:
		if(Job==0)
			index=7;
		else if(Job==1)
			index=8;
		break;
	case RT_DWARF :
		index=9;
		break;
	case RT_KAMAEL:
		if(Gender==1)
			index=11;
		else
			index=10;
		break;
	}

	return index;
}


function CameraMove(int state)
{
	local int Race;
	local int Job;
	local int Gender;

	Race = m_hCbRace.GetSelectedNum();
	Job = m_hCbJob.GetSelectedNum();
	Gender = m_hCbSex.GetSelectedNum();


	
	if(state > m_CameraState)		// ī�޶� ���� ����
	{
		CameraMoveForward(Race, Job, Gender);
	}
	else if(state == m_CameraState)		//  ī�޶� ���� �̵�
	{
		CameraMoveParallelTransference(state, Race, Job, Gender);
	}
	else if(state < m_CameraState)		//  ī�޶� ������ 
	{
		CameraMoveBackward(state, Race, Job, Gender);
	}
}

function CameraMoveForward(int Race, int Job, int Gender)
{
	local string EventName;

	//int Race = m_hCbRace.GetSelectedNum();
	//int Job = m_hCbJob.GetSelectedNum();
	//int Gender = m_hCbSex.GetSelectedNum();

//	NCString str;
	if (Race >= 0) 
	{
//		str.Add((TCHAR*)RACE_STR[Race]);
		EventName=RACE_STR[Race];
		m_CameraState = 1;
	}
	if (Job >= 0) 
	{
//		str.Add(TEXT("_"));
//		str.Add(JOB_STR[Job]);
		EventName=EventName$"_";
		EventName=EventName$JOB_STR[Job];
		m_CameraState = 2;
	}
	
	if (Gender >= 0) 
	{
		if(Job==0) 
		{
		//	str.Add(TEXT("_K"));
			EventName=EventName$"_K";
		}
		else if(Job==1) 
		{
//			str.Add(TEXT("_W"));
			EventName=EventName$"_W";
		}
//		str.Add(SEX_STR[Gender]);
		EventName=EventName$SEX_STR[Gender];
		m_CameraState = 3;
	}

//	afxMainConsole()->SetCurrentMakingRace(Race);
//	afxMainConsole()->ExecLobbyEvent(str.GetBuffer());
	SetCurrentMakingRace(Race);
	ExecLobbyEvent(EventName);
}

function CameraMoveParallelTransference(int state, int Race, int Job, int Gender)
{
	local string EventName;

	if(state==1)							//������ �̵�
	{
//		str.Add((TCHAR*)RACE_STR[Race]);
		EventName=RACE_STR[Race];
//		afxMainConsole()->SetCurrentMakingRace(Race);
//		afxMainConsole()->ExecLobbyEvent(str.GetBuffer());
		SetCurrentMakingRace(Race);
		ExecLobbyEvent(EventName);
	}
	else if(state==2)							// ������ �̵�
	{
		if(Race != 4 && Race !=5)
		{
//			str.Add((TCHAR*)RACE_STR[Race]);
//			str.Add(TEXT("_"));
			EventName=RACE_STR[Race];
			EventName=EventName$"_";

			if( Job==0 ) 
			{
//				str.Add((TCHAR*)JOB_STR[1]);
				EventName=EventName$JOB_STR[1];
			}
			else if(Job==1) 
			{
//				str.Add((TCHAR*)JOB_STR[0]);
				EventName=EventName$JOB_STR[0];
			}

			//str.Add(TEXT("_"));
			//str.Add((TCHAR*)JOB_STR[Job]);
			EventName=EventName$"_";
			EventName=EventName$JOB_STR[Job];

			SetCurrentMakingRace(Race);
			ExecLobbyEvent(EventName,false);
		}
	}
	else if(state==3)							// ������ �̵�
	{
//		str.Add((TCHAR*)RACE_STR[Race]);
		EventName=RACE_STR[Race];
		if(Job==0) 
		{
//			str.Add(TEXT("_K"));
			EventName=EventName$"_K";
		}
		else if(Job==1) 
		{
//			str.Add(TEXT("_W"));
			EventName=EventName$"_W";
		}
		if(Gender==0) 
		{
//			str.Add(SEX_STR[1]);
			EventName=EventName$SEX_STR[1];
		}
		else if(Gender==1) 
		{
//			str.Add(SEX_STR[0]);
			EventName=EventName$SEX_STR[0];
		}

		if(Job==0) 
		{
//			str.Add(TEXT("_K"));
			EventName=EventName$"_K";
		}
		else if(Job==1) 
		{
//			str.Add(TEXT("_W"));
			EventName=EventName$"_W";
		}
//		str.Add(SEX_STR[Gender]);
		EventName=EventName$SEX_STR[Gender];

		SetCurrentMakingRace(Race);
		ExecLobbyEvent(EventName);
	}
}

function CameraMoveBackward(int state, int Race, int Job, int Gender)
{
	local string EventName;

//	NCString str;
	if(state == 1)	//�ٸ� ���� WARP
	{
//		str.Add((TCHAR*)RACE_STR[Race]);
		EventName=RACE_STR[Race];

		//afxMainConsole()->SetCurrentMakingRace(Race);
		//afxMainConsole()->ExecLobbyEvent(str.GetBuffer());
		SetCurrentMakingRace(Race);
		ExecLobbyEvent(EventName);
		m_CameraState = 1;
	}
	else if(state == 2) //�ٸ� ���� ������
	{
		if(Race != 4 && Race !=5)
		{
//			str.Add((TCHAR*)RACE_STR[Race]);
			EventName=RACE_STR[Race];
			
			//str.Add(TEXT("_"));
			//str.Add(JOB_STR[Job]);
			EventName=EventName$"_";
			EventName=EventName$JOB_STR[Job];

			if(Job==1) 
			{
//				str.Add(TEXT("_K"));
				EventName=EventName$"_K";
			}
			else if(Job==0) 
			{
//				str.Add(TEXT("_W"));
				EventName=EventName$"_W";
			}
//			str.Add(SEX_STR[Gender]);
			EventName=EventName$SEX_STR[Gender];

			//afxMainConsole()->SetCurrentMakingRace(Race);
			//afxMainConsole()->ExecLobbyEvent(str.GetBuffer(),true);
			SetCurrentMakingRace(Race);
			ExecLobbyEvent(EventName,true);

			m_CameraState = 2;
		}
	}
}

function EnableRotate(bool bRotate)
{
	local int index;

	local int Race;
	local int Job;
	local int Sex;

	Race = m_hCbRace.GetSelectedNum();
	Job = m_hCbJob.GetSelectedNum();
	Sex = m_hCbSex.GetSelectedNum();

	if(bRotate)
	{
		m_hBtnRotateLeft.ShowWindow();
		m_hBtnRotateRight.ShowWindow();

		if(m_bZoomed)
		{
			m_hBtnZoomOut.ShowWindow();
			m_hBtnZoomIn.HideWindow();
		}
		else
		{
			m_hBtnZoomOut.HideWindow();
			m_hBtnZoomIn.ShowWindow();
		}
		
		index = GetDefaultCharacterIndex(Race, Job, Sex);
		ShowOnlyOneDefaultCharacter(index);
	}
	 else
	{
		m_hBtnRotateLeft.HideWindow();
		m_hBtnRotateRight.HideWindow();
		m_hBtnZoomIn.HideWindow();
		m_hBtnZoomOut.HideWindow();
		m_bZoomed = false;
	}
}

function SetCameraChar(int a_CharIndex)
{
	local string strParam;
	ParamAdd(strParam, "CharIndex", string(a_CharIndex));
	ExecuteEvent(EV_USER_CharacterSelectionChanged, strParam);
}
defaultproperties
{
}
