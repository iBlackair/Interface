class RadarMapWnd extends UICommonAPI;

const OBJ_TYPE_MONSTER=1;
const OBJ_TYPE_PARTYMEMBER=2;
const OBJ_TYPE_CLANMEMBER=3;
const OBJ_TYPE_ALLIANCEMEMBER=4;
const OBJ_TYPE_ITEM=5;
const OBJ_TYPE_ADENA=6;

const MAX_HIDE_POS=79;

const TIMER_ID=123;
const TIMER_DELAY=1700;			    // ���� ������ ��û�ϴ� ���� �� micro second�� ������ �޴´�. 

const TIMER_ID2=124;
const TIMER_ID3=125;
const TIMER_DELAY2=1000;			// ������ Ÿ�̸�

const TIMER_ID4=126;		        //ǥ�� �Ұ� ���� �ؽ�Ʈ�� ������ Ÿ�̸�
const TIMER_DELAY4=3000;	

const TARGET_RADAR_ID=7777;			//Ÿ�� ���̵� �̸� �ϳ� �Ҵ��ص�

const DX = 3130;
const DY = 3130;

const MAX_MONSTER=20;
const MAX_PARTY= 8;

const MAG_1= 1.5;	
const MAG_2= 1.3;
const MAG_3= 1.0;
const MAG_4= 0.7;
//const MAG_5= 0.5;

const MIN_MAG= 1;
const MAX_MAG= 4;

const REQUEST_DISTANCE = 2000;	        // ��ġ���� ��û �ݰ�
const REQUEST_PARTY_DISTANCE = 5000;	// ��ġ���� ��û �ݰ�
const REQUEST_PARTY_DISTANCE_1 = 14000;	// ������ ���� ��Ƽ�� ��ġ ���� ǥ�� �ݰ�	// MAG_1 ~4 �� 1:1�� ��Ī�ȴ�.
const REQUEST_PARTY_DISTANCE_2 = 12000;	
const REQUEST_PARTY_DISTANCE_3 = 9000;	
const REQUEST_PARTY_DISTANCE_4 = 6000;	
const REQUEST_HEIGHT = 800;         	// ��ġ���� ��û ����

const LIGHT_ALPHA = 250;     	        // �׵θ��� �������� ���İ�

const ROTATE_TIME = 500;	            // ȸ�� �ð�
const ROTATE_TIMER_ID = 127;	        // ȸ�� ����� ó���� �� �͵��� ó�����ִ� Ÿ�̸�

const ALPHA_TIME = 100;              	// ȸ�� �� ���İ� ���۵Ǵ� �ð�
const ALPHA_TIMER_ID = 128;

const FS_TIME = 45000;	                // �ý��� Ʃ�丮���� �����ϰ� ���̴� �ð�	//45�ʿ� 1ȸ��
const FS_TIMER_ID = 151;	            // Ÿ�̸� ���̵�

const EDGE_GRAY = 15;
const EDGE_BLUE = 12;
const EDGE_ORANGE = 11;
const EDGE_BUFFRED = 9;
const EDGE_RED = 8;
const EDGE_SSQGRAY = 13;
const EDGE_PVPGREEN = 14;

var bool isRotating;	            	// �����̼��� �Ǵ� ���� ��� �׼��� ���´�.

var RadarMapCtrlHandle	m_hRadarMapCtrl;

var WindowHandle		m_hRadarMapWnd;
var WindowHandle		m_radarOptionWnd;
var WindowHandle		m_hRadarMapRotationWnd;
var WindowHandle		m_RadarMapForWnd;
var WindowHandle		m_RadarMapBackWnd;
var WindowHandle		m_raderBack;

var TextureHandle		m_seaBg;
var TextureHandle		m_compas;
var TextureHandle		m_TexMyPosition;

var ButtonHandle		m_optionWnd;

var CheckBoxHandle      checkPartyView;
var CheckBoxHandle      checkMonsterView;
var CheckBoxHandle      checkMyPos;
var CheckBoxHandle      checkFixView;

// ������ ���� �ڵ�
var WindowHandle FlightStatusGauges;
var StatusBarHandle barFuel;
var BarHandle barMP;
var BarHandle barHP;
var TextBoxHandle ShipNameTxt;	     // ������ �̸� "%s ������ ������"

// ������ �� ���� �ڵ�
var WindowHandle FlightStatusAltitude;
var TextureHandle FlightAltitudeGaugeTex;

var string m_WindowName;
var vector MyPosition;

var string m_TargetName;		     // Ÿ�� ������ �ӽ� �����Ѵ�. 
var vector m_TargetPosition;
var int m_TargetID;
var int m_MyID;


var int arr_MonsterID[MAX_MONSTER];	 // ������ ID�� �����ϴ� �迭
var int arr_PartyID[MAX_PARTY];		 // ��Ƽ���� ID�� �����ϴ� �迭
var int arr_PartyLocX[MAX_PARTY];	 // ��Ƽ���� ��ġ����
var int arr_PartyLocY[MAX_PARTY];	 // ��Ƽ���� ��ġ����
var int arr_PartyLocZ[MAX_PARTY];	 // ��Ƽ���� ��ġ����
var string arr_PartyName[MAX_PARTY]; // ��Ƽ���� �̸�

var float mag;
var float arrMag[6];
var int magStep;					//�ܰ踦 �����Ѵ�. 

var int arrPartyDistWithMag[6];		// ������ ���� ��Ƽ�� ǥ�� �ݰ�

var bool bLockClick;

// ���̴� ���� ����
var bool onshowstat1;
var bool onshowstat2;
var int globalAlphavalue1;
var int globalyloc;
var float numberstrange;
var int global_move_val;

var bool showMonster;
var bool hideParty;
var bool inParty;		    // ���� ��Ƽ�� �����ִ��� Ȯ��
var bool inGamingState;		// ���� ���� ������Ʈ���� Ȯ��
var bool showMe;	        // �� ��ġ ǥ�� ���̱�/ ���߱�
var bool fixRadar;	        // ���̴� ����

var bool isFrontSide;	    // �����ΰ�
var bool isOnFSTimer;	    // �ý��� Ʃ�丮���� �����ִ��� Ȯ��
var bool isFreeShip;	    // ���� �������ΰ�?  true �̸� ����,  false �̸� ���� ������

//var TextBoxHandle	m_movingText;
var TextBoxHandle	m_textboxmove;
var TextBoxHandle	m_textNoMap;
var TextureHandle	m_texZone;

// PC��, ��õ ���� â �� �� , ��� 
//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
var RecommendBonusWnd	RecommendBonusWndScript;	// ��õ ����â 
var PCCafeEventWnd	PCCafeEventWndScript;	    // PC�� ����Ʈ â

var ButtonHandle	m_hRecommendBonusWndToggleButton;
var ButtonHandle	m_hPCCafeEventWndToggleButton;

var TextureHandle	m_hRecommendBonusToggleButtonRingTex;
var TextureHandle	m_hPCCafeEventWndToggleButtonRingTex;
//end of branch

function OnRegisterEvent()
{
	RegisterEvent(EV_SetRadarZoneCode);
	RegisterEvent( EV_BeginShowZoneTitleWnd );		//�������� �ٲ� ��, ���̴��� �������� ������ �����ؾ��Ѵ�. 
	RegisterEvent( EV_ShowMinimap );	
	RegisterEvent( EV_NotifyObject);
	
	RegisterEvent( EV_PartyAddParty); 
	RegisterEvent( EV_PartyDeleteParty);
	RegisterEvent( EV_PartyDeleteAllParty);
	RegisterEvent( EV_NotifyPartyMemberPosition);
	
	registerEvent( EV_GamingStateEnter );
	registerEvent( EV_GamingStateExit );
	
	RegisterEvent( EV_TargetUpdate );				//Ÿ�� ������Ʈ �� ��� Ÿ���� ǥ�����ش�.
	RegisterEvent( EV_TargetHideWindow );			//Ÿ���� ���̵� �ɰ�� Ÿ�� ����
	
	RegisterEvent( EV_FinishRotate);	//ȸ�� ����� ������ �̺�Ʈ
	
	RegisterEvent( EV_AirShipState );	// ������ ������Ʈ�� ������ ���
	RegisterEvent( EV_AirShipUpdate );	// ������ ���� ������Ʈ �̺�Ʈ
	RegisterEvent( EV_AirShipAltitude);	// ������ ���� ����Ǿ��� ���
	
	//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
	RegisterEvent(EV_PCCafePointInfo);
	RegisterEvent(EV_ReceiveNewVoteSystemInfo);
	//end of branch
}

function OnLoad()
{
	RegisterState( "RadarMapWnd", "DebugState");

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	m_WindowName="RadarMapWnd";

	if(CREATE_ON_DEMAND==0)
	{
		m_hRadarMapWnd=GetHandle(m_WindowName);
		m_hRadarMapCtrl=RadarMapCtrlHandle(GetHandle(m_WindowName$".RadarMapCtrl"));
		m_radarOptionWnd=GetHandle("RadarOptionWnd");
		m_hRadarMapRotationWnd = GetHandle("RadarMapWnd.RadarMapRotationWnd");

		m_RadarMapForWnd = GetHandle("RadarMapWnd.RadarMapForWnd");
		m_RadarMapBackWnd = GetHandle("RadarMapWnd.RadarMapBackWnd");
		
		m_textboxmove = TextBoxHandle(GetHandle(m_WindowName$".textboxmove"));
		m_texZone = TextureHandle(GetHandle(m_WindowName$".texZone"));	
		m_seaBg = TextureHandle(GetHandle(m_WindowName$".texSeaBg"));
		m_compas = TextureHandle(GetHandle(m_WindowName$".texHighLight"));
		m_TexMyPosition = TextureHandle(GetHandle(m_WindowName$".TexMyPosition"));
		m_textNoMap = TextBoxHandle(GetHandle(m_WindowName$".textNoMap"));
		m_optionWnd = ButtonHandle(GetHandle(m_WindowName$".btnOption"));
			
		checkPartyView = CheckBoxHandle ( GetHandle( "RadarMapWnd.RadarMapBackWnd.checkPartyView" ) );
		checkMonsterView = CheckBoxHandle ( GetHandle( "RadarMapWnd.RadarMapBackWnd.checkMonsterView" ) );
		checkMyPos = CheckBoxHandle ( GetHandle( "RadarMapWnd.RadarMapBackWnd.checkMyPos" ) );
		checkFixView = CheckBoxHandle ( GetHandle( "RadarMapWnd.RadarMapBackWnd.checkFixView" ) );
		
		// ������ ���� �ڵ� �ʱ�ȭ
		FlightStatusGauges = GetHandle( "RadarMapWnd.FlightStatusGauges" );
		barFuel = StatusBarHandle ( GetHandle( "RadarMapWnd.FlightStatusGauges.barFuel" ) );		
		barMP = BarHandle ( GetHandle( "RadarMapWnd.FlightStatusGauges.barMP" ) );
		barHP = BarHandle ( GetHandle( "RadarMapWnd.FlightStatusGauges.barHP" ) );	
		ShipNameTxt = TextBoxHandle ( GetHandle( "RadarMapWnd.FlightStatusGauges.ShipNameTxt" ) );
		
		FlightStatusAltitude = GetHandle( "RadarMapWnd.FlightStatusAltitude" );
		FlightAltitudeGaugeTex = TextureHandle( GetHandle("RadarMapWnd.FlightStatusAltitude.FlightAltitudeGaugeTex" ));

		//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
		m_hPCCafeEventWndToggleButton = GetButtonHandle("RadarMapWnd.pcCafeEventWndToggleButton");
		m_hRecommendBonusWndToggleButton = GetButtonHandle("RadarMapWnd.recommendBonusWndToggleButton");
		
		m_hRecommendBonusToggleButtonRingTex = GetTextureHandle("RadarMapWnd.recommendBonusWndToggleButtonRing");
		m_hPCCafeEventWndToggleButtonRingTex = GetTextureHandle("RadarMapWnd.pcCafeEventWndToggleButton_Ring");
		//end of branch
	}
	else
	{
		m_hRadarMapWnd=GetWindowHandle(m_WindowName);
		m_hRadarMapCtrl=GetRadarMapCtrlHandle(m_WindowName$".RadarMapCtrl");
		m_radarOptionWnd=GetWindowHandle("RadarOptionWnd");
		m_hRadarMapRotationWnd = GetWindowHandle("RadarMapWnd.RadarMapRotationWnd");

		m_RadarMapForWnd = GetWindowHandle("RadarMapWnd.RadarMapForWnd");
		m_RadarMapBackWnd = GetWindowHandle("RadarMapWnd.RadarMapBackWnd");
		
		m_textboxmove = GetTextBoxHandle(m_WindowName$".textboxmove");
		m_texZone = GetTextureHandle (m_WindowName$".texZone");	
		m_seaBg = GetTextureHandle (m_WindowName$".texSeaBg");
		m_compas = GetTextureHandle (m_WindowName$".texHighLight");
		m_TexMyPosition = GetTextureHandle (m_WindowName$".TexMyPosition");
		m_textNoMap = GetTextBoxHandle(m_WindowName$".textNoMap");
		m_optionWnd = GetButtonHandle(m_WindowName$".btnOption");
			
		checkPartyView = GetCheckBoxHandle ( "RadarMapWnd.RadarMapBackWnd.checkPartyView" );
		checkMonsterView = GetCheckBoxHandle ( "RadarMapWnd.RadarMapBackWnd.checkMonsterView" );
		checkMyPos = GetCheckBoxHandle ( "RadarMapWnd.RadarMapBackWnd.checkMyPos" );
		checkFixView = GetCheckBoxHandle ( "RadarMapWnd.RadarMapBackWnd.checkFixView" );
		
		// ������ ������ ���� �ڵ� �ʱ�ȭ
		FlightStatusGauges = GetWindowHandle( "RadarMapWnd.FlightStatusGauges" );
		barFuel = GetStatusBarHandle( "RadarMapWnd.FlightStatusGauges.barFuel" );
		barMP = GetBarHandle( "RadarMapWnd.FlightStatusGauges.barMP" );
		barHP = GetBarHandle( "RadarMapWnd.FlightStatusGauges.barHP" );
		ShipNameTxt = GetTextBoxHandle ( "RadarMapWnd.FlightStatusGauges.ShipNameTxt" );
		
		FlightStatusAltitude = GetWindowHandle( "RadarMapWnd.FlightStatusAltitude" );
		FlightAltitudeGaugeTex = GetTextureHandle( "RadarMapWnd.FlightStatusAltitude.FlightAltitudeGaugeTex" );
		
		//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
		m_hPCCafeEventWndToggleButton = GetButtonHandle("RadarMapWnd.pcCafeEventWndToggleButton");
		m_hRecommendBonusWndToggleButton = GetButtonHandle("RadarMapWnd.recommendBonusWndToggleButton");
		
		m_hRecommendBonusToggleButtonRingTex = GetTextureHandle("RadarMapWnd.recommendBonusWndToggleButtonRing");
		m_hPCCafeEventWndToggleButtonRingTex = GetTextureHandle("RadarMapWnd.pcCafeEventWndToggleButton_Ring");
		//end of branch
	}
	
	inGamingState = false;
	
	bLockClick = false;
	InitDatas();
	m_hOwnerWnd.EnableTick();
	
	isFreeShip = false;
	FlightGaugesClear();	// ������ ���� ������ �ʱ�ȭ

	RecommendBonusWndScript = RecommendBonusWnd( GetScript("RecommendBonusWnd") );
	PCCafeEventWndScript = PCCafeEventWnd( GetScript("PCCafeEventWnd") );	
	
	//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
	m_hPCCafeEventWndToggleButton.HideWindow();
	m_hPCCafeEventWndToggleButtonRingTex.HideWindow();
	
	m_hRecommendBonusWndToggleButton.HideWindow();
	m_hRecommendBonusToggleButtonRingTex.HideWindow();
	//end of branch
}

function InitDatas()
{
	local int i;
	local UserInfo	MyInfo;
	
	local vector vec;
	vec.x=-1.0;
	vec.y=-1.0;
	vec.z=0.0;

	// ������ ���� �ʱ�ȭ
	isOnFSTimer = false;
	m_hRadarMapWnd.KillTimer( FS_TIMER_ID );
	
	init_textboxmove();
	//class'UIAPI_WINDOW'.static.HideWindow("movingtext");
	onshowstat1 = false;
	onshowstat2 = false;
	globalAlphavalue1 = 0;
	globalyloc = 0;
	numberstrange =0;
	global_move_val =0;
	
	//inParty = false;
	
	//MyPosition = GetPlayerPosition();
	//m_hRadarMapCtrl.AddObject(1, "Self", "", MyPosition.x, MyPosition.y, MyPosition.z);
	
	// �⺻������ ���̴°����� ǥ��  // �ɼǿ��� �����´�. 
	showMonster = GetOptionBool("Game", "radarShowMonster");
	hideParty = GetOptionBool("Game", "radarHideParty");
	showMe = GetOptionBool("Game", "radarShowMe");
	fixRadar = GetOptionBool("Game", "radarFix");
	inParty = false;
	
	if(showMonster == true)	checkMonsterView.SetCheck(true);
	else	checkMonsterView.SetCheck(false);
		
	if(hideParty == true)	checkPartyView.SetCheck(true);
	else	checkPartyView.SetCheck(false);
		
	if(showMe == true)	checkMyPos.SetCheck(true);
	else	checkMyPos.SetCheck(false);
		
	if(fixRadar == true)	checkFixView.SetCheck(true);
	else	checkFixView.SetCheck(false);
	
	for(i=0; i<MAX_MONSTER; i++)	arr_MonsterID[i] = -1;
	for(i=0; i<MAX_PARTY; i++)		
	{
		arr_PartyID[i] = -1;
		arr_PartyLocX[i]  = -1;
	}
	
	ClearObject();
	m_hRadarMapWnd.KillTimer( TIMER_ID );
	m_hRadarMapWnd.KillTimer( TIMER_ID2 );
	m_hRadarMapWnd.KillTimer( TIMER_ID3 );
	CheckTimer();
	OptionApply();
	
	arrMag[MIN_MAG] = MAG_1;
	arrMag[MIN_MAG + 1] = MAG_2;
	arrMag[MIN_MAG + 2] = MAG_3;
	arrMag[MIN_MAG + 3] = MAG_4;
	//arrMag[MIN_MAG + 4] = MAG_5;
	
	arrPartyDistWithMag[MIN_MAG] = REQUEST_PARTY_DISTANCE_1;
	arrPartyDistWithMag[MIN_MAG + 1] = REQUEST_PARTY_DISTANCE_2;
	arrPartyDistWithMag[MIN_MAG + 2] = REQUEST_PARTY_DISTANCE_3;
	arrPartyDistWithMag[MIN_MAG + 3] = REQUEST_PARTY_DISTANCE_4;
	
	mag=MAG_3;
	magStep = 3;
	m_hRadarMapCtrl.SetMagnification(mag);
	
	m_TargetName = "";
	m_TargetID = -1;
	
	GetPlayerInfo( MyInfo );
	
	m_MyID = MyInfo.nID;
	
	m_textNoMap.HideWindow();	// "ǥ�� �Ұ� ����" �ؽ�Ʈ�� �⺻������ ��������. 
	
	m_textboxmove.SetText("");			//�� ǥ�ø� �ʱ�ȭ����
	m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_gray");	
	
	if(!showMe)	//�̰�false�̸� �� ��ġ�� �����ش�. 
	{
		m_TexMyPosition.HideWindow();
		m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring_Cross");
	}
	else		//true �̸� ������
	{
		m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring");
		m_TexMyPosition.ShowWindow();
	}	
	
	if(isFrontSide == false )
	{
		vec.x=-1.0;
		vec.y=-1.0;
		vec.z=0.0;
		m_hRadarMapRotationWnd.SetAlpha(255);
		m_RadarMapBackWnd.SetAlpha(0);
		//m_RadarMapBackWnd.Rotate(false,1,vec, 0,0,false,0);	// �޸��� �ʱ�ȭ ���ش�.
		m_RadarMapBackWnd.HideWindow();	
	}
	
	isFrontSide = true;
}

function OnShow()
{

	
	//m_RadarMapBackWnd.HideWindow();
	//m_RadarMapBackWnd.ShowWindow();
}

function SetTexZoneColor(int type)
{
	switch (type)
	{
		//Ordinary Field: Grey
		case EDGE_GRAY:
		m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_gray");
		break;
		
		//Peace Zone: Blue
		case EDGE_BLUE:
		m_texZone.SetTexture( "L2UI_CT1.radarmap_df_region_blue");
		break;
		
		//Siege Warfare Zone: Orange
		case EDGE_ORANGE:
		m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_orange");
		break;
		
		//Buff Zone: Green
		case EDGE_BUFFRED:
		m_texZone.SetTexture( "L2UI_CT1.radarmap_df_region_red");
		break;
		
		//DeBuff Zone: Red
		case EDGE_RED:
		m_texZone.SetTexture( "L2UI_CT1.radarmap_df_region_red");
		break;
		
		//SSQZone: Grey
		case EDGE_SSQGRAY:
		m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_gray");	

		break;
		
		//PVPZone: Green
		case EDGE_PVPGREEN:
		m_texZone.SetTexture("L2UI_CT1.radarmap_df_region_green");	
		break;
	}
}
function SetTexZoneInfo(int type)
{
	switch (type)
	{
		//Ordinary Field: Grey
		case EDGE_GRAY:
		m_textboxmove.SetText(GetSystemString(1284));
		break;
		
		//Peace Zone: Blue
		case EDGE_BLUE:
		m_textboxmove.SetText(GetSystemString(1285));
		break;
		
		//Siege Warfare Zone: Orange
		case EDGE_ORANGE:
		m_textboxmove.SetText(GetSystemString(1286));
		break;
		
		//Buff Zone: Green
		case EDGE_BUFFRED:
		m_textboxmove.SetText(GetSystemString(1287));
		break;
		
		//DeBuff Zone: Red
		case EDGE_RED:
		m_textboxmove.SetText(GetSystemString(1288));
		break;
		
		//SSQZone: Grey
		case EDGE_SSQGRAY:
		m_textboxmove.SetText(GetSystemString(1289));

		break;
		
		//PVPZone: Green
		case EDGE_PVPGREEN:
		m_textboxmove.SetText( GetSystemString(1290));
		break;
	}

}
function CheckTimer()	// �� ��Ȳ���� Ÿ�̸Ӹ� ���� ������ �Ǵ��� üũ�ϰ�, ������ �ȴٸ� Ÿ�̸� �⵿
{
	if(showMonster == true || (hideParty == false && inParty == true))	// ��ġ�� ����� �� ������ Ÿ�̸� ����!
	{
		m_hRadarMapWnd.KillTimer( TIMER_ID );
		m_hRadarMapWnd.SetTimer(TIMER_ID,TIMER_DELAY);
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	// �����̴� �ؽ�Ʈ ǥ��
	local int type;
	
	switch( a_EventID )
	{
	case EV_ShowMinimap:	
		break;
	
	case EV_NotifyObject :
		HandleNotifyObject(a_Param);
		break;
	
	case EV_SetRadarZoneCode:
		ParseInt( a_Param, "ZoneCode", type );
		HandleRadarZoneCode(type);
		break;
	
	case EV_PartyAddParty:
		HandlePartyAddParty(a_Param);
		break;
	
	case EV_PartyDeleteParty:
		HandlePartyDeleteParty(a_Param);
		break;
	
	case EV_PartyDeleteAllParty:
		HandlePartyDeleteAllParty();
		break;
	
	case EV_NotifyPartyMemberPosition:
		HandleNotifyPartyMemberPosition(a_Param);
		break;
	
	case EV_GamingStateEnter:
		inGamingState = true;
		break;
	
	case EV_GamingStateExit:
		inGamingState = false;	
		ClearObject();
		InitDatas();
		break;
	
	case EV_BeginShowZoneTitleWnd:
		HandleZoneTitle();
		break;
	
	case EV_TargetUpdate:
		HandleTargetUpdate();
		break;
	
	case EV_TargetHideWindow:
		HandleTargetHideWindow();
		break;
	
	case EV_FinishRotate:
		HandleFinishRotate(a_Param);
		break;
	
	case EV_AirShipState:
		OnAirShipState( a_Param );
		break;
	
	case EV_AirShipUpdate:
		OnAirShipUpdate( a_Param );
		break;
	
	case EV_AirShipAltitude:
		OnAirShipAltitude( a_Param );
		break;
	
	//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
	case EV_PCCafePointInfo:
		OnShowPCCafeButton();
		break;
	
	case EV_ReceiveNewVoteSystemInfo: 
		OnShowNewVoteSystemButton();
		break;
	//end of branch
	
	}
}

function HandleTargetUpdate()
{
	local UserInfo	info;
	local UserInfo	MyInfo;
	
	//Ư�� �Ÿ��� ����� �Ǹ� �������ش�.
	GetTargetInfo(info);
	GetPlayerInfo( MyInfo );	// 	
	
	m_MyID = MyInfo.nID;
	
	if(info.nID == m_MyID)
	{
		 return;
	}
	
	m_TargetID = info.nID;
	m_TargetName =  info.Name;
	m_TargetPosition = info.Loc;
	
	m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//�����.
	
	if (isFrontSide == true)	// �ո��� ��쿡�� Ÿ���� ����ش�.
	{
		if( info.Name != "")
		{
			m_hRadarMapCtrl.AddObject(TARGET_RADAR_ID, "Target",  info.Name, info.Loc.x, info.Loc.y,  info.Loc.z);	
		}
	}
}

function HandleTargetHideWindow()
{
	m_TargetName = "";
	m_TargetID = -1;
	m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//�����.
}

function HandlePartyAddParty(String param )
{
	local int ID;
	local int idx;
	local string Name;	
	
	//debug("HandlePartyAddParty !!" $ param);
	inParty = true;

	// �ʿ��� �����͸� �Ľ��Ѵ�. 
	ParseInt(param, "ID", ID);
	ParseString(Param, "Name", Name);
	
	//��Ƽ�� �߰��� �迭�� ID�� �����Ѵ�. 
	if( FindPartyIDX(ID) > -1)	// �̹� �迭�� ID�� ������ ������ �ִ°�
	{
		//debug("ERROR PartyID : " $ FindPartyIDX(ID) );
		return;
	}
	else
	{
		idx = findEmptyPartySlot();
		if(idx == -1)	//�� ��Ƽ�� ������ ��� ����
		{
			//debug("ERROR - No Empty Slot!! ");
			return;
		}
		else	// ��Ƽ�� ���� ID�� �迭�� �����Ѵ�. 
		{
			//debug(" idx : " $ idx $ " ID : " $ ID);
			arr_PartyID[idx] = ID;
			arr_PartyName[idx] = Name;
		}
	}
	
	HandleOntimer();	//�� �ѹ� ��������	
	CheckTimer();
}

function HandlePartyDeleteParty(String param )
{
	local int ID;
	local int idx;
	
	ParseInt(param, "ID", ID);
	
	//Ư�� ��Ƽ���� ����
	idx = FindPartyIDX(ID);
	if( idx > -1)	
	{
		m_hRadarMapCtrl.DeleteObject( arr_PartyID[idx]);
		arr_PartyLocX[idx]  = -1;
		arr_PartyID[idx] = -1;		
	}
	else//  �迭�� ID�������� ������ �ִ°�
	{
		//debug("ERROR NO PartyID : " $ ID );
		return;
	}
	
	HandleOntimer();	//�� �ѹ� ��������
}

function HandlePartyDeleteAllParty()
{
	local int i;
	inParty = false;
	
	// ��� ��Ƽ�� ���� ����
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		m_hRadarMapCtrl.DeleteObject( arr_PartyID[i]);
		arr_PartyLocX[i]  = -1;
		arr_PartyID[i] = -1;
	}
		
	ClearObject();	//��� ������Ʈ �����ֱ�
	
	HandleOntimer();	//�� �ѹ� ��������
}

// ��Ƽ�� ���� ������Ʈ ��Ŷ
function HandleNotifyPartyMemberPosition(String param )
{
	// ���� ������� �ʴ� �̺�Ʈ
	// �Ÿ��� �ָ� �����Ѵ�. 
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{

}

function HandleOntimer()
{
	// ��� ������Ʈ �����
	ClearObject();
	
	if (isFrontSide == true && isRotating == false)	// ���� ǥ���� ��� ���� �ո��� ��쿡�� 
	{
		if(inGamingState)	// �������� ��쿡��
		{
			if(showMonster)
			{
				m_hRadarMapCtrl.RequestObjectAround(OBJ_TYPE_MONSTER, REQUEST_DISTANCE, REQUEST_HEIGHT);
			}
			if(hideParty == false && inParty == true)
			{
				//debug("request party!!");
				AddPartyObject();	//���� ������ �ִ� ��� ��Ƽ�� �����͸� �ֵ����ش�. 
				GetPartyLocation();	//�̴ϸʿ� �ִ� ��Ƽ���� ��ġ������ �����ͼ� �����Ѵ�.
				m_hRadarMapCtrl.RequestObjectAround(OBJ_TYPE_PARTYMEMBER, arrPartyDistWithMag[magStep] , REQUEST_HEIGHT);	
			}
		}
		
		if( showMonster == false && (hideParty == true || inParty == false) )	// �Ѵ� ���������� Ÿ�̸Ӹ� �׿��ش�. 
		{
			//debug("kill timer");
			m_hRadarMapWnd.KillTimer( TIMER_ID );
			ClearObject();
		}
	}
}

//���� ������ �ִ� ��� ��Ƽ�� �����͸� �ֵ����ش�. 
function AddPartyObject()
{
	local int i;
	local int distance;
	
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		if(arr_PartyID[i] != -1)
		{
			distance = GetDistanceFromMe(arr_PartyLocX[i], arr_PartyLocY[i], arr_PartyLocZ[i]);
			
			//debug("arr_PartyLocX[i] : " $ arr_PartyLocX[i]);
			//debug("ID : " $ arr_PartyID[i]  $ " distance : " $ distance );
			
			if( distance < arrPartyDistWithMag[magStep]  && distance > -1)	// Ư�� �ݰ� �̳��� ��Ƽ���� �߰��Ѵ�.  (������ ����)
			{
				m_hRadarMapCtrl.AddObject( arr_PartyID[i] , "PartyMember", arr_PartyName[i], arr_PartyLocX[i], arr_PartyLocY[i], arr_PartyLocZ[i]);
				
				if(m_TargetID != -1 && m_TargetID == arr_PartyID[i])	//Ÿ���� ��Ƽ���ϰ��, ���� �ֽ��� ��ġ������ ����
				 {
					 m_TargetPosition.x = arr_PartyLocX[i];
					 m_TargetPosition.y = arr_PartyLocY[i];
					 m_TargetPosition.z = arr_PartyLocZ[i];
					 m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//�����.
					 m_hRadarMapCtrl.AddObject(TARGET_RADAR_ID, "Target",  m_TargetName , m_TargetPosition.x, m_TargetPosition.y,  m_TargetPosition.z);	
				 }
			}
		}			
	}
}

// �̴ϸ� �����Ͱ� ������ �ִ� ��� ��Ƽ�� ������ �����Ѵ�. 
function GetPartyLocation()
{
	local int i;
	local Vector PartyMemberLocation;
	
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		if(arr_PartyID[i] != -1)
		{
			if(GetPartyMemberLocationWithID( arr_PartyID[i], PartyMemberLocation ))	//���� ���� ��쿡��
			{
				if(arr_PartyLocX[i] != -1)	// -1�� ���� ���ٴ� ������~
				{
					arr_PartyLocX[i] = PartyMemberLocation.x;
					arr_PartyLocY[i] = PartyMemberLocation.y;
					arr_PartyLocZ[i] = PartyMemberLocation.z;
				}
			}
		}			
	}
}

// Ư�� ��ǥ�� �� ��ġ���� �Ÿ��� ���.
function int GetDistanceFromMe( int x, int y, int z)
{
	local int distance;
	local int distX;
	local int distY;
	MyPosition = GetPlayerPosition();	// �� ��ġ ����
	
	//distance = int( Sqrt ( ( x - MyPosition.x ) ^ 2 + (y - MyPosition.y) ^ 2 ));
	distX = x - MyPosition.x;
	distY = y - MyPosition.y;
	distance =  int( Sqrt (distX * distX + distY * distY ));
	return distance;
}

//�ɼ� ���� ��ȯ ó�� // ����ġ ǥ�� �� ���̴� ����
function OptionApply()
{
	local int nZoneID;
	
	nZoneID = GetCurrentZoneID();
	
	//if(inGamingState)	// �������� ��쿡��
	//{		
		if(!showMe)	//�̰�false�̸� �� ��ġ�� �����ش�. 
		{
			m_TexMyPosition.HideWindow();
			m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring_Cross");
		}
		else		//true �̸� ������
		{
			m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring");
			m_TexMyPosition.ShowWindow();
		}
		
		if(fixRadar)	//�̰�true�̸鷹�̴� ȸ�� ���� 
		{
			m_hRadarMapCtrl.ClearRotation();
			m_compas.ClearRotation();
			m_hRadarMapCtrl.SetEnableRotation(false);
			m_compas.SetAutoRotateType( ETART_None );		//��ħ�� ��ɵ� ����
			m_TexMyPosition.SetRotatingDirection(1);
			m_TexMyPosition.SetAutoRotateType( ETART_Camera );	//�� ǥ�ô� ī�޶�� ���� ����
			//m_TexMyPosition.HideWindow();
		}
		else		//false �̸� ���̴� ȸ��
		{
			m_hRadarMapCtrl.SetEnableRotation(true);
			if(IsHidePositionZone(nZoneID) == false)	//��ħ���� �����ϴ� ���̶�� ȸ����ų �ʿ䰡 ����. 
			{
				m_compas.SetAutoRotateType( ETART_Camera );		//��ħ�� ��ɵ� ȸ��
			}
			m_TexMyPosition.ClearRotation();
			m_TexMyPosition.SetAutoRotateType( ETART_None );
			//m_TexMyPosition.ShowWindow();
		}
	//}
}

// ������ ������ ���
function HandleNotifyObject(string a_Param)
{
	local string Type;
	local int ID;
	local string Name;
	local int LocX;
	local int LocY;
	local int LocZ;
	local int idx;
	
	ParseString(a_Param, "Type", Type);
	ParseInt(a_Param, "ID", ID);
	ParseString(a_Param, "Name", Name);

	ParseInt(a_Param, "X", locX);
	ParseInt(a_Param, "Y", locY);
	ParseInt(a_Param, "Z", locZ);

	//debug("�䱸�Ѱ� - Type:"$Type$", ID:"$ID$", Name:"$Name$", X:%d"$locX$", Y:%d"$locY$", Z:%d"$locZ);
	
	// ������Ʈ �߰��ϱ�
	if(Type == string(OBJ_TYPE_MONSTER))	// �����ϰ��
	{	
		if( FindMonsterIDX(ID) > -1)
		{
			//debug("Update MonsterID : " $ FindMonsterIDX(ID) );
			m_hRadarMapCtrl.UpdateObject( ID , locX, locY, locZ);
		}
		else
		{
			idx = findEmptyMonsterSlot();
			if(idx == -1)
			{
				//debug("ERROR - overflow monster array!! ");
				return;
			}
			else
			{
				if( FindMonsterIDX(ID) == -1)
				{
					m_hRadarMapCtrl.AddObject( ID , "Monster", Name, locX, locY, locZ);
					
					 if(m_TargetID != -1 && m_TargetID == ID)
					 {
						 m_TargetPosition.x = locX;
						 m_TargetPosition.y = locY;
						 m_TargetPosition.z = locZ;
						 m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//�����.
						 m_hRadarMapCtrl.AddObject(TARGET_RADAR_ID, "Target",  m_TargetName , m_TargetPosition.x, m_TargetPosition.y,  m_TargetPosition.z);	
					 }
				}
				arr_MonsterID[idx] = ID;
				//debug("add idx : " $ idx $ " ID : " $ ID);
			}
		}
	}	
	else if(Type == string(OBJ_TYPE_PARTYMEMBER))	// ��Ƽ���ϰ��
	{	
		idx = FindPartyIDX(ID);
		if( idx > -1)	//��Ƽ���� �߰��� �� ID�� ����ȴ�. �׿ܿ��� ����.
		{
			//��ġ������ �迭�� �����صд�.
			arr_PartyLocX[idx] = locX;
			arr_PartyLocY[idx] = locY;
			arr_PartyLocZ[idx] = locZ;
			//debug("PartyID : "$  ID );
			//m_hRadarMapCtrl.UpdateObject( ID , locX, locY, locZ);
		}
		else	//���� ����� ������ �ȵȴ�.	AddPartyObject() ���� �̹� add�� �߱� ������
		{
			//GetPartyMemberLocationWithID( ID, PartyMemberLocation );
			//debug("PartyMemberLocation : " $ PartyMemberLocation);
			
			if (m_MyID != ID)	//�� �̿��� ��Ƽ���� �̰����� ������ �ȵ�.
			{
				//debug("ERROR - Can't Find Party Member with ID" $ ID $ " idx : " $ idx);
			}			
			/*
			idx = findEmptyPartySlot();
			if(idx == -1)
			{
				//debug("ERROR - overflow party array!! ");
				return;
			}
			else
			{
				if( FindPartyIDX(ID) == -1 && m_MyID != ID)	//�ڽ��� ��� �߰����� ����
				{
					m_hRadarMapCtrl.AddObject( ID , "PartyMember", Name, locX, locY, locZ);
					
					if(m_TargetID != -1 && m_TargetID == ID)
					 {
						 m_TargetPosition.x = locX;
						 m_TargetPosition.y = locY;
						 m_TargetPosition.z = locZ;
						 m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	//�����.
						 m_hRadarMapCtrl.AddObject(TARGET_RADAR_ID, "Target",  m_TargetName , m_TargetPosition.x, m_TargetPosition.y,  m_TargetPosition.z);	
					 }
				}
				arr_PartyID[idx] = ID;
			}
			*/
		}
	}
	
	// �Ÿ� �ۿ� �ִ� ������Ʈ�� �����ش�.
	//removeFarObject();
}

function ClearObject()
{
	local int  i;
	for(i=0 ; i<MAX_MONSTER ; i++)
	{
		//debug("delete 22 ID : " $ arr_MonsterID[i] $ " delete i " $ i );
		if(arr_MonsterID[i] != -1)
		{
			//debug("delete ID : " $ arr_MonsterID[i] $ " delete i " $ i );
			m_hRadarMapCtrl.DeleteObject( arr_MonsterID[i]);
			arr_MonsterID[i] = -1;
		}	
			
	}
	
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		if(arr_PartyID[i] != -1)
		{
			m_hRadarMapCtrl.DeleteObject( arr_PartyID[i]);
			//arr_PartyID[i] = -1;	//��Ƽ���� ������ delete party������ ����
		}			
	}
}

function int findEmptyMonsterSlot()
{
	local int  i;
	for(i=0 ; i<MAX_MONSTER ; i++)
	{
		if(arr_MonsterID[i] == -1)
		{
			return i;
		}			
	}	
	return -1;
}

function int findEmptyPartySlot()
{
	local int  i;
	for(i=0 ; i<MAX_PARTY ; i++)
	{
		if(arr_PartyID[i] == -1)
		{
			return i;
		}			
	}	
	return -1;
}

// Ÿ�̸� �����̸���  ��ġ������ ��û�Ѵ�. 
function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		HandleOntimer();
	}
	
	if(TimerID == TIMER_ID4)
	{
		m_hRadarMapWnd.KillTimer( TIMER_ID4 );
		m_textNoMap.SetAlpha( 0, 0.8f );		
	}
	
	if(TimerID == ROTATE_TIMER_ID)
	{
		RotateProcess();	//������ â �Ⱥ����� â�� �����Ѵ�.
		m_hRadarMapWnd.KillTimer( ROTATE_TIMER_ID);
	}
	
	if(TimerID == ALPHA_TIMER_ID)
	{
		m_RadarMapForWnd.SetAlpha(0, 0.1f);	// ���ĸ� �׿��ش�.  -> ���缭���� ���� �̺�Ʈ������ ���İ� �������� ����
		m_hRadarMapWnd.KillTimer( ALPHA_TIMER_ID);
	}
	
	if(TimerID == FS_TIMER_ID)
	{
		if(!GetOptionBool( "Game", "SystemTutorialBox" ))	// �ý��� Ʃ�丮�� üũ�ڽ��� Ȯ���� �־�� �Ѵ�. 
		{	
			ShowAirShipTutorial(-1);	// �ý��� �޼��� ���� �߰�
		}
		else
		{
			isOnFSTimer = false;
			m_hRadarMapWnd.KillTimer( FS_TIMER_ID );	// Ÿ�̸Ӹ� �׿��ش�.
		}

	}
}

function OnClickButton( String a_ButtonID )
{
	local  RadarOptionWnd script1;	// ���̴� ��ũ��Ʈ ��������
	script1 = RadarOptionWnd( GetScript("RadarOptionWnd") );
	
	if(isRotating == true)	return;	//ȸ�����̸� �ƹ��͵� ���� �ʴ´�.
	
	switch( a_ButtonID )
	{
		case "TargetButton":
			break;
		case "BtnOption":
			clickRotateButton();
			break;
		case "BtnPlus":
			if(magStep < MAX_MAG)
			{
				magStep++;
				mag = arrMag[magStep];
				//debug("now Mag : " $ mag);
				m_hRadarMapCtrl.SetMagnification(mag);
			}
			break;
		case "BtnMinus":
			if(magStep > MIN_MAG)
			{
				magStep--;
				mag = arrMag[magStep];
				//debug("now Mag : " $ mag);
				m_hRadarMapCtrl.SetMagnification(mag);
			}
			break;
		case "recommendBonusWndToggleButton" :  
			RecommendBonusWndScript.visibleToggleWnd();

			break;
		case "pcCafeEventWndToggleButton" :  
			// pc�� ����Ʈ â�� ������, �Ⱥ����� ��� �ϱ� 
			PCCafeEventWndScript.HandleToggleShowPCCafeEventWnd();
			break;

	}
}

// üũ�ڽ��� Ŭ���Ͽ��� ��� �̺�Ʈ
function OnClickCheckBox( string CheckBoxID)
{
	switch( CheckBoxID )
	{
	case "checkPartyView":
		if(checkPartyView.IsChecked())		// ��Ƽ�� ���̱� üũ�ڽ� ó��
		{
			hideParty = true;
			SetOptionBool( "Game", "radarHideParty", true );
		}
		else 
		{
			hideParty = false;
			SetOptionBool( "Game", "radarHideParty", false );
		}
	case "checkMonsterView":
		if(checkMonsterView.IsChecked())		// ���� ���̱� üũ�ڽ� ó��
		{
			showMonster = true;
			SetOptionBool( "Game", "radarShowMonster", true );
		}
		else 
		{
			showMonster = false;
			SetOptionBool( "Game", "radarShowMonster", false );
		}
		break;
	case "checkMyPos":
		if(checkMyPos.IsChecked())			// ��ǥ�� ���߱� üũ�ڽ� ó��
		{
			showMe = true;
			SetOptionBool( "Game", "radarShowMe", true );
		}
		else 
		{
			showMe = false;
			SetOptionBool( "Game", "radarShowMe", false );
		}
		break;
	case "checkFixView":
		if(checkFixView.IsChecked())		// ���̴� ���� ó��
		{
			fixRadar = true;
			SetOptionBool( "Game", "radarFix", true );
		}
		else 
		{
			fixRadar = false;
			SetOptionBool( "Game", "radarFix", false );
		}
		break;
	}
}

// ��-> ������ ���� �� ���İ� �����Ǵ� ������ ó��
function RotateProcess()
{
	if (isFrontSide == true)
	{
		isFrontSide = false;		
		// ����� ������ �ȵȴ�.
		//debug("ERROR!! ");
	}
	else	//�ٽ� ������
	{			
		if(m_RadarMapBackWnd.isShowWindow())	m_RadarMapBackWnd.HideWindow();
		
		OptionApply();	//�ɼ�����
		CheckTimer();
		isFrontSide = true;		
	}
	
	isRotating = false;
}


// ������ ����
function clickRotateButton()
{
	local vector vec;
	vec.x=-1.0;
	vec.y=-1.0;
	vec.z=0.0;

	isRotating = true;
	
	if (isFrontSide == true)		// �ڷ� ������ ����
	{	
		m_hRadarMapCtrl.DeleteObject(TARGET_RADAR_ID);	// Ÿ���� �����ش�.
		
		// ������ �߿��� �� ���İ� ���ϸ� �ȵȴ�.	
		if(globalAlphavalue1 < 500)
		{
			m_textboxmove.SetAlpha(  0);
			m_texZone.SetAlpha( LIGHT_ALPHA );
			onshowstat1 = true;
			onshowstat2 = false;
			globalAlphavalue1 = 500;
		}
		
		if(!m_RadarMapForWnd.isShowWindow()) m_RadarMapForWnd.ShowWindow();		
		if(!m_RadarMapBackWnd.isShowWindow())	m_RadarMapBackWnd.ShowWindow();
			
		m_hRadarMapRotationWnd.SetAlpha(0, 0.5f);
		
		m_RadarMapForWnd.Rotate(false, 400, vec, 255, 255, false, 5);
		//m_RadarMapBackWnd.Rotate(false, 400, vec, 0, 255, false, 6);		
	}
	else
	{	
		m_RadarMapBackWnd.SetAlpha(0, 0.5f);
		
		m_RadarMapForWnd.Rotate(false, 400, vec, 255, 255, false, 5);
		
		//m_RadarMapBackWnd.Rotate(false, 400, vec, 255, 0, false, 6);
	}
}

function HandleFinishRotate( string Param )
{
	local String	winName;
	
	ParseString(Param, "WindowName", winName);
	
	if( winName == "RadarMapForWnd")
	{
		if(isFrontSide == true)
		{			
			//isFrontSide = false;
			//isRotating = false;
			m_RadarMapBackWnd.SetAlpha(255, 0.1f);
			m_hRadarMapWnd.SetTimer(ALPHA_TIMER_ID,ALPHA_TIME);	// ���İ��� �ִ� Ÿ�̸�, �ش� �ð� ��  ���İ� �۵� �ȴ�.
			m_hRadarMapWnd.SetTimer(ROTATE_TIMER_ID,ROTATE_TIME);	// ���İ� ���ư��� ������ Ÿ�̸�
		}
		else
		{	
			m_hRadarMapRotationWnd.SetAlpha(255, 0.1f);
			m_hRadarMapWnd.SetTimer(ALPHA_TIMER_ID,ALPHA_TIME);	// ���İ��� �ִ� Ÿ�̸�, �ش� �ð� ��  ���İ� �۵� �ȴ�.
			m_hRadarMapWnd.SetTimer(ROTATE_TIMER_ID,ROTATE_TIME);	// ���İ� ���ư��� ������ Ÿ�̸�
		}
	}
	
}

// ���̴� ���� ����
function HandleRadarZoneCode( int type )
{
	local Color Red;
	local Color Blue;
	local Color Grey;
	local Color Orange;
	local Color Green;
	Red.R = 50;
	Red.G = 0;
	Red.B = 0;
	Blue.R = 0;
	Blue.G = 0;
	Blue.B = 50;
	Grey.R = 30;
	Grey.G = 30;
	Grey.B = 30;
	Orange.R = 60;
	Orange.G = 30;
	Orange.B = 0;
	Green.R = 0;
	Green.G = 50;
	Green.B = 0;
	resetanimloc();
	onshowstat2 = true;
	
	m_textboxmove.ShowWindow();
	m_textboxmove.SetAlpha( 0 );
	m_texZone.SetAlpha( 0 );
	m_textboxmove.SetAlpha( 255, 0.8f );
	m_texZone.SetAlpha( 255 , 0.8f );
	SetTexZoneInfo(type);

	SetTexZoneColor(type);
}

function SetRadarColor( Color a_RadarColor, float a_Seconds )
{
	//class'UIAPI_RADAR'.static.SetRadarColor( "RadarContainerWnd.Radar", a_RadarColor, a_Seconds );
}



function OnTick()
{
	if (onshowstat2 == true)
	{
		fadeIn();
	}
	if (onshowstat1 == true)
	{
		fadeOut();
	}	
}

function fadeIn()
{
	globalAlphavalue1 = globalAlphavalue1 + 3;
	if (globalAlphavalue1 >= 255 &&  globalAlphavalue1 < 500)	// �� ���ֵ��� �����̸� �ش�. globalAlphavalue1�� ���̻� ���İ� �ƴ� -_-;; ���� Ÿ�̸� üũ �����ϻ�!!
	{
		m_textboxmove.SetAlpha( 255);
		m_texZone.SetAlpha( 255);
	}
	else if( globalAlphavalue1 >= 500 )
	{
		m_textboxmove.SetAlpha(  0, 0.8f );
		m_texZone.SetAlpha(  LIGHT_ALPHA, 0.8f );
			
		//class'UIAPI_WINDOW'.static.Move( "RadarMapWnd.textboxmove", -30, 0, 0.8f );
		onshowstat1 = true;
		onshowstat2 = false;
	}
}

function fadeOut()
{
	//global_move_val = move_value();
	globalAlphavalue1 = globalAlphavalue1 - 2;
	globalyloc = globalyloc + 1;
	
	if( globalAlphavalue1 <= 1)
	{
		m_textboxmove.SetAlpha( 0);
		m_textboxmove.HideWindow();
		globalyloc = 0;
		global_move_val =0;
		globalAlphavalue1 = 0;
		onshowstat1 = false;
		onshowstat2 = false;
	}
}

function int move_value()
{
	local int movevalue;
	numberstrange = numberstrange + 0.5;
	if (numberstrange < 1)
	{
		movevalue = 0;
		return movevalue;
	} 
	if (numberstrange == 1)
	{
		movevalue = -1;
		numberstrange = 0;
		return movevalue;
	}
}	

function resetanimloc()
{
	//class'UIAPI_WINDOW'.static.Move("movingtext", 0,globalyloc/2);
	onshowstat1 = false;
	onshowstat2 = false;
	globalyloc = 0;
	global_move_val =0;
	globalAlphavalue1 = 0;
}


function init_textboxmove()
{
	m_textboxmove.SetText("");
}

//ID�� �迭�� �ε����� ���Ѵ�. 
function int FindPartyIDX(int ID)
{
	local int idx;
	for (idx=0; idx<MAX_PARTY; idx++)
	{
		if (arr_PartyID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ID�� �迭�� �ε����� ���Ѵ�. 
function int FindMonsterIDX(int ID)
{
	local int idx;
	for (idx=0; idx<MAX_MONSTER; idx++)
	{
		if (arr_MonsterID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

// ��Ÿ��Ʋ�� �ٲ� ID�� ���� �̴ϸ��� �������� �����Ѵ�. 
function HandleZoneTitle()
{
	local int nZoneID;
	nZoneID = GetCurrentZoneID();
	
	//debug("nZoneID : " $ nZoneID);
	if(m_textNoMap. isShowWindow())	//��Ÿ��Ʋ�� �ٲ𶧴� �׻� ǥ�úҰ����� �ؽ�Ʈ�� �����ش�. 
	{
		m_hRadarMapWnd.KillTimer( TIMER_ID4 );
		m_textNoMap.HideWindow();
	}
	
	if( IsHideRadarZone(nZoneID) )
	{
		//���̴��� ������. 
		if(m_seaBg.IsShowWindow())
		{
			//m_hRadarMapCtrl.HideWindow();
			m_hRadarMapCtrl.SetMapInvisible(true);
			m_seaBg.HideWindow();
		}
		
		if(IsHidePositionZone(nZoneID))	//��ħ���� ������ų ��ġ�ΰ� // Ÿ�� ǥ�õ� ������� �ȴ�.  // ��ٿ��
		{
			m_compas.ClearRotation();
			m_compas.SetAutoRotateType( ETART_None );		//��ħ�� ��ɵ� ����
			m_hRadarMapCtrl.HideWindow();
			m_optionWnd.DisableWindow();
			
			// �ɼ� ������ �������� �ִٸ�, �ո����� �����ش�. 
			if(isFrontSide == false)	clickRotateButton();
			
			//��ٿ��� �ɼǿ� ������� ����ġǥ�ø� �����ش�.
			m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring_Cross");	
			m_TexMyPosition.HideWindow();
		}
		else
		{
			if(fixRadar == false)	//�̰�true�̸鷹�̴� ȸ�� �����̱� ������ ��ħ�� ȸ���� ������ �ʿ䰡 ����.
				m_compas.SetAutoRotateType( ETART_Camera );		//��ħ�� ���ȸ��
			m_optionWnd.EnableWindow();
			if(!m_seaBg.IsShowWindow())
			{
				m_hRadarMapCtrl.ShowWindow();
			}
		}

		// ǥ�� �Ұ� ���� �ؽ�Ʈ�� �����ش�.			
		m_textNoMap.SetAlpha( 0 );
		m_textNoMap.ShowWindow();			
		m_textNoMap.SetAlpha( 255, 0.8f );
		
		m_hRadarMapWnd.KillTimer( TIMER_ID4 );
		m_hRadarMapWnd.SetTimer(TIMER_ID4,TIMER_DELAY4);
		
	}
	else
	{
		//���̴��� �������� �������� -> ���� �������� �̵����� ��� ���̴��� �����ش�.  
		if(!m_seaBg.IsShowWindow())
		{
			
			if(!m_hRadarMapCtrl.IsShowWindow())	//����Ʈ���� ������ �ִٸ� ������
			{
				m_hRadarMapCtrl.ShowWindow();
			}
			m_hRadarMapCtrl.SetMapInvisible(false);
			m_seaBg.ShowWindow();
			
			if(fixRadar == false)	//�̰�true�̸鷹�̴� ȸ�� �����̱� ������ ��ħ�� ȸ���� ������ �ʿ䰡 ����.
				m_compas.SetAutoRotateType( ETART_Camera );		//��ħ�� ��� ����
			
			m_optionWnd.EnableWindow();
			
			//��ٿ�忡�� �Ϲ� �ʵ�� ������ ���
			// �� ��ġ ���߱Ⱑ false �ε� m_TexMyPosition�� HIde �����̸� �ٽ� �������ش�.			
			if((showMe) && (!m_TexMyPosition.IsShowWindow()))
			{
				m_compas.SetTexture("L2UI_CT1.RadarMap.RadarMap_DF_Ring");
				m_TexMyPosition.ShowWindow();
			}
		}
		
	}
}

// ������ ���� �Լ���
// ������ ������ �ʱ�ȭ
function FlightGaugesClear()
{
	barHP.SetValue(100, 100);
	barMP.SetValue(100, 100);
	
	barHP.SetAlpha(100);
	barMP.SetAlpha(100);
	barFuel.SetPoint(0, 0);
}

// ������ ž�� ������Ʈ�� �˷��ش�. 
function OnAirShipState( string a_Param )
{
	local int VehicleID;
	local int IsDriver;
	//~ local UserInfo info;
	//~ local string ClanName;
	local vehicle myAirShip;
	
	ParseInt( a_Param, "VehicleID", VehicleID );
	ParseInt( a_Param, "IsDriver", IsDriver );
	
	myAirShip = class'VehicleAPI'.static.GetVehicle( VehicleID );
	
	if(myAirShip.MaxFuel > 0)
	{
		isFreeShip = true;
		barFuel.SetPoint(myAirShip.CurFuel, myAirShip.MaxFuel);	// ���Ḧ ������Ʈ �Ѵ�. 
		
		if(myAirShip.CurFuel == 0)	{	AddSystemMessage(2464);	}		//	�ٴڳ�
		else	if(myAirShip.CurFuel < 50)	{	AddSystemMessage(2463);	}	//	�� �ٴڳ�
		
		ShipNameTxt.SetText(  GetSystemMessage(2454) );	//ũ������ũ�� ���༱
		
		//if( GetPlayerInfo( info ) )	// ������ �̸��� �޾ƿͼ�
		//{		
			//ClanName =  class'UIDATA_CLAN'.static.GetName(info.nClanID);			
			//ShipNameTxt.SetName(  MakeFullSystemMsg( GetSystemMessage(2454), ClanName ) , NCT_Normal,TA_Left);	// "%s �� �������̶�� �����ش�.
		//}
	}
	else
	{
		isFreeShip = false;
	}
		
	if(VehicleID > 0)	// �������� ž������ ���
	{
		if(isFreeShip)
		{
			if(!GetOptionBool( "Game", "SystemTutorialBox" ))
			{
				// ���⼭ Ÿ�̸Ӹ� �Ҵ�.
				if(!isOnFSTimer)	// Ÿ�̸Ӱ� �������� �������� �Ҵ�.
				{	
					isOnFSTimer = true;
					ShowAirShipTutorial(2742);
					ShowAirShipTutorial(2741);
					m_hRadarMapWnd.SetTimer( FS_TIMER_ID,FS_TIME );
				}
				else
				{
					if(IsDriver > 0)
					{
						ShowAirShipTutorial(2494);	// �ý��� �޼����� ������ �������ش�.
						ShowAirShipTutorial(2495);
					}
				}
			}		
		
			if(!FlightStatusGauges.isShowWindow()) FlightStatusGauges.ShowWindow();		//�������� �����ֱ�
			if(!FlightStatusAltitude.isShowWindow()) FlightStatusAltitude.ShowWindow();		//�� �����ֱ�
		}
	}
	else	// ���������� ������ ���
	{		
		isFreeShip = false;
		if(isOnFSTimer)	m_hRadarMapWnd.KillTimer( FS_TIMER_ID );		// Ÿ�̸Ӱ� ���������� ����.
		isOnFSTimer = false;

		
		if(FlightStatusGauges.isShowWindow()) FlightStatusGauges.HideWindow();		//�������� ����
		if(FlightStatusAltitude.isShowWindow()) FlightStatusAltitude.HideWindow();		//�� ����
	}			
}

// ������ ���� ������Ʈ
function OnAirShipUpdate( string a_Param )
{
	local vehicle myAirShip;
	local int VehicleID;
	
	ParseInt( a_Param, "VehicleID", VehicleID );
	
	myAirShip = class'VehicleAPI'.static.GetVehicle( VehicleID );
	
	//barHP.SetValue( myAirShip.CurHP, myAirShip.MaxHP);	// ���� HP�� ���� �ּ��� ����!
	
	if(myAirShip.MaxFuel > 0)
	{		
		barFuel.SetPoint(myAirShip.CurFuel, myAirShip.MaxFuel);	// ���Ḧ ������Ʈ �Ѵ�. 
		if(myAirShip.CurFuel == 0)	{	AddSystemMessage(2464);	}		//	�ٴڳ�
		else	if(myAirShip.CurFuel < 50)	{	AddSystemMessage(2463);	}	//	�� �ٴڳ�
	}
}

// �� ����� ������� ������Ʈ ����
function OnAirShipAltitude( string a_Param )
{
	local int m_nGodo;
	
	ParseInt( a_Param, "Z" , m_nGodo);
	
	updateAltitudeTex( m_nGodo );
	
}

function ShowAirShipTutorial( int SystemMsgID)
{
	local int RandVal;
	local int RandSystemMsgID;
	
	if(SystemMsgID < 0)	// 0���� ������ ������ �ý��� �޼����� �����ش�. 
	{
		RandVal = Rand(8);
		
		RandSystemMsgID = 2494;	// ������ ���� ����Ʈ�� -_-
		
		switch(RandVal)
		{
			case 0:	RandSystemMsgID = 2494;		break;		// ������ �ý��� �޼��� ���̵� �����ش�
			case 1:	RandSystemMsgID = 2495;		break;
			case 2:	RandSystemMsgID = 2496;		break;
			case 3:	RandSystemMsgID = 2497;		break;
			case 4:	RandSystemMsgID = 2498;		break;
			case 5 :	RandSystemMsgID = 2741;		break;
			case 6:	RandSystemMsgID = 2742;		break;
			case 7:	RandSystemMsgID = 2422;		break;
		}
	}
	else
	{
		RandSystemMsgID = SystemMsgID;
	}
	
	if(!GetOptionBool( "Game", "SystemTutorialBox" ))	// �ý��� Ʃ�丮�� üũ�ڽ��� Ȯ���� �־�� �Ѵ�. 
	{	
		AddSystemMessage(RandSystemMsgID);	// �ý��� �޼��� �߰�
	}
	else
	{
		isOnFSTimer = false;
		m_hRadarMapWnd.KillTimer( FS_TIMER_ID );	// Ÿ�̸Ӹ� �׿��ش�.
	}
}

// �� �ؽ��ĸ� ������Ʈ �Ѵ�. 
function updateAltitudeTex( int altitude)
{
	local int m_nLayer;
	
	m_nLayer = 1;	//�⺻�����δ�  1 (�ϰ͵� �Ⱥ��̴� �ܰ� - �ؽ��� ���ӿ� �����ڴ�)	
	m_nLayer = LayerOfAltitude(altitude);	//���̾� �ܰ踦 �����´�.	���̾�� 1~ 14���� (�ؽ��� ���Ӱ� ����)
	
	if( m_nLayer < 10)
	{
		FlightAltitudeGaugeTex.SetTexture("L2UI_ct1.RadarMap.RadarMap_df_Altitude_Gage_0" $ m_nLayer);
	}
	else
	{
		FlightAltitudeGaugeTex.SetTexture("L2UI_ct1.RadarMap.RadarMap_df_Altitude_Gage_" $ m_nLayer);
	}
	
	//AltitudeTxt.SetText(string(m_nZ + 4000));	// ���� ������Ʈ ���ش�. 	
}

// �������� �� �ܰ踦 �����Ѵ�. �ܰ�� 1�ܰ迡�� 14 �ܰ���� ���� 
function int LayerOfAltitude ( int altitude )
{
	local int returnLayer;
		
	if(altitude  >= 6000 )	returnLayer = 14;
	else if(altitude  >= 5500 )	returnLayer = 13;
	else if(altitude  >= 5000 )	returnLayer = 12;
	else if(altitude  >= 4500 )	returnLayer = 11;
	else if(altitude  >= 4000 )	returnLayer = 10;
	else if(altitude  >= 3500 )	returnLayer = 9;
	else if(altitude  >= 3000 )	returnLayer = 8;
	else if(altitude  >= 2500 )	returnLayer = 7;
	else if(altitude  >= 2000 )	returnLayer = 6;
	else if(altitude  >= 1500 )	returnLayer = 5;
	else if(altitude  >= 1000 )	returnLayer = 4;
	else if(altitude  >= 500 )	returnLayer = 3;
	else if(altitude  >= 0 )	returnLayer = 2;
	else					returnLayer = 1;		
	
	return returnLayer;
}

//�̴ϸ��� ���� �����̸� true ����. ������ �����̸� false ����
function bool IsHideRadarZone(int nZoneID)
{	
	//debug("nZoneID : " $ nZoneID);
	switch(nZoneID)
	{
		//���̴��� ���� ����
		case 17:
		case 28:
		case 32:
		case 33:
		case 45:
		case 54:
		case 55:
		case 56:
		case 60:
		case 65:
		case 66:
		case 69:
		case 79:
		case 80:
		case 81:
		case 82:
		case 83:
		case 84:
		case 85:
		case 86:
		case 87:
		case 88:
		case 89:
		case 90:
		case 91:
		case 92:
		case 110:
		case 114:
		case 119:
		case 121:
		case 125:
		case 126:
		case 127:
		case 128:
		case 129:
		case 130:
		case 131:
		case 132:
		case 133:
		case 134:
		case 135:
		case 136:
		case 137:
		case 138:
		case 139:
		case 140:
		case 142:
		case 143:
		case 145:
		case 152:
		case 159:
		case 162:
		case 164:
		case 165:
		case 177:
		case 178:
		case 185:
		case 273:
		case 274:
		case 275:
		case 276:
		case 278:
		case 279:
		case 281:		//4�뿵��
		case 282:
		case 283:
		case 284:
		case 285:
		case 286:		// 4�뿵��
		case 303:
		case 304:
		case 306:
		case 311:		// �ø��ǾƵ� �����
		case 316:
		case 317:
		case 318:
		case 319:
		case 320:
		case 321:
		case 336:
		case 339:
		case 340:		// �������� ����
		case 341:
		case 358:
		case 359:
		case 360:
		case 363:		//��ٿ��
		case 364:		//��ٿ��
		case 365:
		case 366:
		case 367:
		case 368:
		case 369:	
		case 370:
		case 371:
		case 372:
		case 373:
		case 374:
		case 375:
		case 376:
		case 377:
		case 378:		//���̾��� ž
		case 379:		//��ö�� ��		//CT 1.5
		case 380:		//��ö�� ��		
		case 381:		//��ö�� ��		//CT 1.5
		case 387:		//�Ͽ��� ����		//CT 1.5
		case	390:		//������ ��Ź��
		case	392:		//��ȣ�� ����
		case	393:		//�Ͽ��� ����
		case	394:		//���޶��� ����
		case	396:		//�����Ǳ�
		case	398:		//��ȣ�� ����
		case	400:		//��ȣ�� ����
		case	401:		//���޶��� ����
		case	410:		//�븣���� ����
		case	412:		//�븣���� ����
		case 443:		//���� �����
		case	452:		//���� �ݷμ���
		case 453:		// ������ ž
		case 454:		// ������ ž
		case 455:		// �緹���� ���ۼ�
		case 456:		// �緹���� ���ۼ�
		case 457:		// ���̾��� ž
		case 458:		// ���̾��� ž
		case 459:		//���� �����
		case 460:		//ī����ī
		case 461:		
		case 462:		
		case 463:		
		case 464:		
		case 465:		
		case 466:		//ī����ī
		case 467:		// TTP 27672
		case 472:		//�Ǹ���
		case 473:		//�������� �ͳ�
		case 474:		//ũ������ ť��
		case 475:		//ũ������ ť��
		case 476:		//ũ������ ť��
		case 490:
			return true;
		
		default:
			return false;
	}		
}

//���� ǥ�ø� ���� �����̸� true ����. ������ �����̸� false ����
function bool IsHidePositionZone(int nZoneID)
{	
	switch(nZoneID)
	{
		//���̴��� ���� ����
		case 311:		// �ø��ǾƵ� �����
		case 363:		//��ٿ��
		case 364:		//��ٿ��
		case 365:
		case 366:
		case 367:
		case 368:
		case 369:
		case 370:
		case 371:
		case 372:
		case 373:
		case 374:
		case 375:
		case 376:
		case 377:
		case 378:
		case 379:		//��ö�� ��		//CT 1.5
		case 380:		//��ö�� ��		//CT 1.5
		case 381:		//��ö�� ��		//CT 1.5
		case 443:		//���� �����
		case 453:		// ������ ž
		case 454:		// ������ ž
		case 455:		// �緹���� ���ۼ�
		case 456:		// �緹���� ���ۼ�
		case 457:		// ���̾��� ž
		case 458:		// ���̾��� ž
			return true;
		
		default:
			return false;
	}		
}



//branch : gorillazin 10. 04. 14. - pc cafe event / new vote event
function OnShowPCCafeButton()
{
	if(!m_hPCCafeEventWndToggleButton.IsShowWindow())
	{
		m_hPCCafeEventWndToggleButton.ShowWindow();
	}
	
	if(!m_hPCCafeEventWndToggleButtonRingTex.IsShowWindow())
	{
		m_hPCCafeEventWndToggleButtonRingTex.ShowWindow();
	}
}

function OnShowNewVoteSystemButton()
{
	if(!m_hRecommendBonusWndToggleButton.IsShowWindow())
	{
		m_hRecommendBonusWndToggleButton.ShowWindow();
	}
	
	if(!m_hRecommendBonusToggleButtonRingTex.IsShowWindow())
	{
		m_hRecommendBonusToggleButtonRingTex.ShowWindow();
	}
}
//end of branch
defaultproperties
{
    
}
