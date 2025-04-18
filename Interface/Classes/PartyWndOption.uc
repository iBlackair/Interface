
class PartyWndOption extends UIScriptEx;
	
const NPARTYSTATUS_MAXCOUNT = 9;		//�� ��Ƽâ�� ���� �ִ� �ִ� ��Ƽ���� ��.

// �������� ����
var bool	m_OptionShow;	// ���� �ɼ�â�� �������� �ִ��� üũ�ϴ� �Լ�.
					// true�̸� ����. false  �̸� ������ ����.
var int	m_arrPetIDOpen[NPARTYSTATUS_MAXCOUNT];	// �ε����� �ش��ϴ� ��Ƽ���� ���� â�� �����ִ��� Ȯ��. 1�̸� ����, 2�̸� ����. -1�̸� ����

// �̺�Ʈ �ڵ� ����
var WindowHandle	m_PartyOption;
var WindowHandle 	m_PartyWndBig;
var WindowHandle	m_PartyWndSmall;

var CheckBoxHandle	m_CheckShowAllPet;
var CheckBoxHandle	m_CheckHideAllPet;

var ComboBoxHandle	cb_AssistBtn;

// ������ ������ �ε�Ǵ� �Լ�
function OnLoad()
{
	local int value;
	m_OptionShow = false;	// ����Ʈ�� false 


	if(CREATE_ON_DEMAND==0)
	{
		m_PartyOption = GetHandle("PartyWndOption");
		m_PartyWndBig = GetHandle("PartyWnd");	
		m_PartyWndSmall = GetHandle("PartyWndCompact");
		
		m_CheckShowAllPet = CheckBoxHandle(GetHandle("PartyWndOption.showAllPet"));
		m_CheckHideAllPet = CheckBoxHandle(GetHandle("PartyWndOption.removeAllPet"));
	}
	else
	{
		m_PartyOption = GetWindowHandle("PartyWndOption");
		m_PartyWndBig = GetWindowHandle("PartyWnd");	
		m_PartyWndSmall = GetWindowHandle("PartyWndCompact");
		
		m_CheckShowAllPet = GetCheckBoxHandle("PartyWndOption.showAllPet");
		m_CheckHideAllPet = GetCheckBoxHandle("PartyWndOption.removeAllPet");
		
		cb_AssistBtn = GetComboBoxHandle("PartyWndOption.cbAssistBtn");
	}
	
	cb_AssistBtn.Clear();
	cb_AssistBtn.AddString("TAB");
	cb_AssistBtn.AddString("Tilde");
	cb_AssistBtn.AddString("Shift");
	cb_AssistBtn.AddString("Ctrl");
	GetINIInt("PartyOptions", "AssistButton", value, "PatchSettings");
	cb_AssistBtn.SetSelectedNum(value);
	GetINIInt("PartyOptions", "DetailedIcons", value, "PatchSettings");
	if (value == 1)
	{
		class'UIAPI_CHECKBOX'.static.SetCheck("PartyWndOption.showNewIcons", true);
	}
	else
	{
		class'UIAPI_CHECKBOX'.static.SetCheck("PartyWndOption.showNewIcons", false);
	}
	GetPatchOptionsInt("ShowNobl", "PartyWndOption.debuffList.noblCheck");
	GetPatchOptionsInt("ShowSOS", "PartyWndOption.debuffList.sosCheck");
	GetPatchOptionsInt("ShowFI", "PartyWndOption.debuffList.fiCheck");
	GetPatchOptionsInt("ShowWW", "PartyWndOption.debuffList.wwCheck");
	GetPatchOptionsInt("ShowMana", "PartyWndOption.debuffList.manaCheck");
	GetPatchOptionsInt("ShowAcumen", "PartyWndOption.debuffList.acumenCheck");
	GetPatchOptionsInt("ShowShield", "PartyWndOption.debuffList.shieldCheck");
	GetPatchOptionsInt("ShowPride", "PartyWndOption.debuffList.prideCheck");
	GetPatchOptionsInt("ShowMDef", "PartyWndOption.debuffList.mdefCheck");
	GetPatchOptionsInt("ShowEmp", "PartyWndOption.debuffList.empCheck");
}

function GetPatchOptionsInt(string section, string handle)
{
	local int value;
	GetINIInt("PartyOptions", section, value, "PatchSettings");
	if (value == 1)
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(handle, true);
	}
	else
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(handle, false);
	}
}

function EInputKey GetAssistKeyName()
{
	local int value;
	value = cb_AssistBtn.GetSelectedNum();
	
	switch (value)
	{
		case 0:
			return IK_Tab;
		break;
		case 1:
			return IK_Tilde;
		break;
		case 2:
			return IK_Shift;
		break;
		case 3:
			return IK_Ctrl;
		break;
	}
}

function OnComboBoxItemSelected (string strID, int Index)
{ 
  switch (strID)
  {
    case "cbAssistBtn":
		SetINIInt("PartyOptions", "AssistButton", Index, "PatchSettings");
	break;
  }
}
       
// �����찡 ������������ ȣ��Ǵ� �Լ�
function OnShow()
{	
	local int i;
	local int open, hide;
	
	class'UIAPI_CHECKBOX'.static.SetCheck("ShowSmallPartyWndCheck", GetOptionBool( "Game", "SmallPartyWnd" ));
	class'UIAPI_WINDOW'.static.SetFocus("PartyWndOption");
	m_OptionShow = true;
	
	open  = 0;
	hide  = 0;	
	// ���� ���� ���¿� ���� ��� �����ֱ� / ��� ���߱��� üũ�� ó���Ѵ�. 
	for(i=0; i<NPARTYSTATUS_MAXCOUNT ; i++)
	{
		if(m_arrPetIDOpen[i] == 1) open++;
		else if(m_arrPetIDOpen[i] == 2) hide++;
	}	
	
	if( open == 0 )	// ��� �����ִٴ� ��. ��� �ݱ��� üũ�� �ڵ����� ���ش�. 
	{
		m_CheckShowAllPet.SetCheck(false);
		m_CheckHideAllPet.SetCheck(true);
	}
	else if( hide == 0)	// ���μ�. open, hide �� ���ÿ� 0�� �� �� ����. 
	{
		m_CheckShowAllPet.SetCheck(true);
		m_CheckHideAllPet.SetCheck(false);
	}
	else	// �������͵� �հ� �ƴѰ͵� ������ �Ѵ� üũ ����
	{
		m_CheckShowAllPet.SetCheck(false);
		m_CheckHideAllPet.SetCheck(false);		
	}
		
}

// üũ�ڽ��� Ŭ���Ͽ��� ��� �̺�Ʈ
function OnClickCheckBox( string CheckBoxID)
{
	local PartyWnd script_pt;
	
	script_pt = PartyWnd(GetScript("PartyWnd"));
	
	switch( CheckBoxID )
	{
	case "ShowSmallPartyWndCheck":
		//debug("Clicked  2");

		break;
	case "showAllPet":
		if(m_CheckShowAllPet.IsChecked() )
			m_CheckHideAllPet.SetCheck(false);
		break;
	case "removeAllPet":
		if(m_CheckHideAllPet.IsChecked() )
			m_CheckShowAllPet.SetCheck(false);
		break;
	case "showNewIcons":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.showNewIcons") )
		{
			script_pt.ChangeMemberIcons();
			SetINIInt("PartyOptions", "DetailedIcons", 1, "PatchSettings");
		}
		else
		{
			script_pt.ChangeMemberIcons();
			SetINIInt("PartyOptions", "DetailedIcons", 0, "PatchSettings");
		}
		break;
	case "noblCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.noblCheck") )
		{
			SetINIInt("PartyOptions", "ShowNobl", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowNobl", 0, "PatchSettings");
		}
		break;
	case "sosCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.sosCheck") )
		{
			SetINIInt("PartyOptions", "ShowSOS", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowSOS", 0, "PatchSettings");
		}
		break;
	case "fiCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.fiCheck") )
		{
			SetINIInt("PartyOptions", "ShowFI", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowFI", 0, "PatchSettings");
		}
		break;
	case "wwCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.wwCheck") )
		{
			SetINIInt("PartyOptions", "ShowWW", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowWW", 0, "PatchSettings");
		}
		break;
	case "manaCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.manaCheck") )
		{
			SetINIInt("PartyOptions", "ShowMana", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowMana", 0, "PatchSettings");
		}
		break;
	case "acumenCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.acumenCheck") )
		{
			SetINIInt("PartyOptions", "ShowAcumen", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowAcumen", 0, "PatchSettings");
		}
		break;
	case "shieldCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.shieldCheck") )
		{
			SetINIInt("PartyOptions", "ShowShield", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowShield", 0, "PatchSettings");
		}
		break;
	case "prideCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.prideCheck") )
		{
			SetINIInt("PartyOptions", "ShowPride", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowPride", 0, "PatchSettings");
		}
		break;
	case "mdefCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.mdefCheck") )
		{
			SetINIInt("PartyOptions", "ShowMDef", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowMDef", 0, "PatchSettings");
		}
		break;
	case "empCheck":
		if(class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.empCheck") )
		{
			SetINIInt("PartyOptions", "ShowEmp", 1, "PatchSettings");
		}
		else
		{
			SetINIInt("PartyOptions", "ShowEmp", 0, "PatchSettings");
		}
		break;
	}
}

// Ȯ��� ��Ƽâ�� ��ҵ� ��Ƽâ�� ��ȯ
function SwapBigandSmall()
{
	local int i;
	//~ local int open, hide;
	
	local  PartyWnd script1;			// Ȯ��� ��Ƽâ�� Ŭ����
	local PartyWndCompact script2;	// ��ҵ� ��Ƽâ�� Ŭ����
	
	script1 = PartyWnd( GetScript("PartyWnd") );
	script2 = PartyWndCompact( GetScript("PartyWndCompact") );
	
	class'UIAPI_WINDOW'.static.SetAnchor("PartyWndCompact", "PartyWnd", "TopLeft", "TopLeft", 0, 0 );	// �̰��ϳ��� ���� â�� ��ũ��. ��!
	
	for(i=0; i <NPARTYSTATUS_MAXCOUNT ; i++)
	{
		if( m_CheckShowAllPet.IsChecked()) 	// ��� ���̱Ⱑ üũ �Ǿ� ������
		{
			if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 1;		//���� ������ ��� �����ش�. 
		}
		else if( m_CheckHideAllPet.IsChecked()) 	// ��� ���߱Ⱑ üũ �Ǿ� ������
		{
			if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 2;		//���� ������ ��� �ݾ��ش�. 
		}
		
		script1.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		script2.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		// ���� ��ũ��Ʈ���� ��� ����.		
	}
	// �� ��ũ��Ʈ�� ResizeWnd()�� �ɼ��� Ȱ��ȭ�� ���� �ڽ��� �����츦 HIDE���� Ȱ��ȭ���� �����Ѵ�. 
	script1.ResizeWnd();
	script2.ResizeWnd();
}

// ��ư�� ������ ��� ����
function OnClickButton( string strID )
{
	//local PartyWnd script1;
	//local PartyWndCompact script2;
	//script1 = PartyWnd( GetScript("PartyWnd") );
	//script2 = PartyWndCompact( GetScript("PartyWndCompact") );
	
	switch( strID )
	{
	case "okbtn":	// OK ��ư�� ������
		
		switch (class'UIAPI_CHECKBOX'.static.IsChecked("ShowSmallPartyWndCheck"))
		{ 
		case true:
			//SetOptionBool("Game", ... ) �� ������ Option ->�����׸񿡼� ����Ҽ� �ִ� bool ������ ����� �� �ִ�.	
			//������ ��ϵ��� ���� ������ ����ϸ� �ڵ����� Ŭ���̾�Ʈ���� �˾Ƽ� ������.
			// ���� ���� ������ ���� Documentation �� �ʿ�!
			// GetOptionBool�� ���.
			SetOptionBool( "Game", "SmallPartyWnd", true );											
			break;
		case false:
			SetOptionBool( "Game", "SmallPartyWnd", false);
			break;
		}
		SwapBigandSmall();		// ��Ȳ�� ���� ��Ƽâ�� ũ�⸦ �������ش�.
		m_PartyOption.HideWindow();	// ������ �����츦 �����
		//script1.m_OptionShow = false;
		//script2.m_OptionShow = false;
		m_OptionShow = false;
		break;
	}
}

// PartyWnd�� PartyWndCompact ���� ȣ���ϴ� �Լ�.
function ShowPartyWndOption()
{
	// ���������� ����
	if (m_OptionShow == false)
	{ 
		m_PartyOption.ShowWindow();
		m_OptionShow = true;
	}
	else	// ���������� �ݴ´�. 
	{
		m_PartyOption.HideWindow();
		m_OptionShow = false;
	}
}
defaultproperties
{
}
