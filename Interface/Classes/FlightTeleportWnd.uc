class FlightTeleportWnd extends UIScriptEx;

// ������
const ICON_FLAG = "L2ui_CT1.MiniMap.Minimap_df_flagicon_yellow";
const ICON_LOC = "L2ui_CT1.MiniMap.Minimap_df_icn_Shield";
const ICON_LOC_DISABLE = "L2ui_CT1.MiniMap.Minimap_df_icn_Shield_disable";

const FLAG_ID = 10001;	//����� ���̵� ������ �����ع�����.


// ���� �ڵ��
var WindowHandle Me;
var WindowHandle FlightShipCtrlWnd;
var MinimapCtrlHandle FlightMap;

var ButtonHandle btnMyPos;
var ButtonHandle btnGo;
var ButtonHandle btnCancle;

var TextBoxHandle TargetTxt;
var TextBoxHandle CostTxt;

//���� ������
var int		 i;					// �ݺ����� ���� ��������

var int 		selectID;				// ���� ���õ� �ڷ���Ʈ ID
var int 		m_airportID;			// ���� �������� ���̵� �޾ƿ��� ��������

var array<int>		m_arrTelID;			// �ڷ���Ʈ ���̵�
var array<int>		m_arrAirportID;		// ������Ʈ ���̵�
var array<int>		m_arrFuel;			// �Ҹ� EP��
var array<int>		m_arrX;			// x, y, z
var array<int>		m_arrY;
var array<int>		m_arrZ;

//-----------------------------------------  �Ʒ� �Լ��� ������ ��ũ��Ʈ ������ �մϴ� -----------------------------------------------
//-----------------------------------------  ������ �� �ڷ���Ʈ ID �� airship.txt ���� ��ũ��Ʈ�� Ȯ���Ͽ��� �մϴ�. -----------------
//---------------------------------------------------------------------------------------------- by innowind --------------------------
function int FindSystemStrByID(int ID, int AirportID )
{
	switch(AirportID)
	{
		case 100:	// ũ������ ���
			switch(ID)
			{
				case -1:		return 1973;	//ũ������ ������ ���
				case 0:		return 1974;	// �Ҹ� ���
				case 1:		return 1975;	// �ĸ� ���
			    case 2:		return 2242;	// ���� ���
			}
			break;
		case 101:	// �Ҹ��� ����
			switch(ID)
			{
				case -1:		return 1974;	// �Ҹ� ���
				case 0:		return 1973;	//ũ������ ������ ���
			}
			break;
		case 102:	// �ĸ��� ����
			switch(ID)
			{
				case -1:		return 1975;	// �ĸ� ���
				case 0:		return 1973;	//ũ������ ������ ���
			}
			break;
		case 103:	// ������ ���� (CT26P1 �߰�)
			switch(ID)
			{
				case -1:		return 2242;	// ���� ���
				case 0:		return 1973;	//ũ������ ������ ���
			}
			break;
	}
}

function OnRegisterEvent()
{
	RegisterEvent( EV_AirShipTeleportListStart );		// �˾� �̺�Ʈ
	RegisterEvent( EV_AirShipTeleportList );			// �ڷ���Ʈ ����Ʈ�� ����´�.
	RegisterEvent( EV_MinimapRegionInfoBtnClick );	// Ŭ���� ���
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
	{
		Initialize();
		OnRegisterEvent();
	}
	else
	{
		InitializeCOD();
	}
	
	FlightMap.SetContinent(1);	// ������ �׷��þƸ� ����Ʈ�� �����ش�. -_-
	clear();
}


function Initialize()
{
	Me = GetHandle( "FlightTeleportWnd" );
	FlightShipCtrlWnd = GetHandle( "FlightShipCtrlWnd" );
	FlightMap = MinimapCtrlHandle ( GetHandle( "FlightTeleportWnd.FlightMap" ));

	btnMyPos = ButtonHandle( GetHandle( "FlightTeleportWnd.btnMyPos" ));
	btnGo = ButtonHandle( GetHandle( "FlightTeleportWnd.btnGo" ));
	btnCancle = ButtonHandle(GetHandle( "FlightTeleportWnd.btnCancle" ));
	
	TargetTxt = TextBoxHandle( GetHandle( "FlightTeleportWnd.TargetTxt" ));
	CostTxt = TextBoxHandle( GetHandle( "FlightTeleportWnd.CostTxt" ));
}

function InitializeCOD()
{
	Me = GetWindowHandle( "FlightTeleportWnd" );
	FlightShipCtrlWnd = GetWindowHandle( "FlightShipCtrlWnd" );
	FlightMap = GetMinimapCtrlHandle( "FlightTeleportWnd.FlightMap" );

	btnMyPos = GetButtonHandle( "FlightTeleportWnd.btnMyPos" );
	btnGo = GetButtonHandle( "FlightTeleportWnd.btnGo" );
	btnCancle = GetButtonHandle( "FlightTeleportWnd.btnCancle" );
	
	TargetTxt = GetTextBoxHandle( "FlightTeleportWnd.TargetTxt" );
	CostTxt = GetTextBoxHandle( "FlightTeleportWnd.CostTxt" );
}

//���� �ʱ�ȭ�� �ٷ��.
function Clear()
{
	FlightMap.EraseAllRegionInfo();
	
	m_arrTelID.Remove(0, m_arrTelID.Length);	// �ڷ���Ʈ �迭 �ʱ�ȭ
	m_arrFuel.Remove(0, m_arrFuel.Length);
	m_arrX.Remove(0, m_arrX.Length);
	m_arrY.Remove(0, m_arrY.Length);
	m_arrZ.Remove(0, m_arrZ.Length);
	
	
		
	selectID = -72;	//�׳� �ʱ�ȭ������ Ȯ��
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_AirShipTeleportListStart:	// �����츦 �˾���Ű��� �̺�Ʈ!
		OnAirShipTeleportListStart( a_Param );
		break;
	case EV_AirShipTeleportList:		// �ڷ���Ʈ ����Ʈ�� ����´�.
		OnAirShipTeleportList( a_Param );
		break;
	case EV_MinimapRegionInfoBtnClick:		// �� ���� ��ư Ŭ���� ����ɴϴ�.
		OnMinimapRegionInfoBtnClick( a_Param );
		break;
	default:
		break;
	}
}

// �����츦 �����ְ�, �̰����� �ʱ�ȭ
function OnAirShipTeleportListStart( String a_Param )
{	
	ParseInt(a_Param, "AirportID", m_airportID);	//������Ʈ ���̵� �޾ƿ´�.
	
	Clear();
	SetMeCenter();
	if(FlightShipCtrlWnd.isShowWindow())	// ���� Ui�� ������ ���� �����ϴ�.
	{
		if(!Me.isShowWindow())
		{
			Me.ShowWindow();	//�˾�
			Me.SetFocus();
		}
	}
	else
	{
		AddSystemMessage(2786);	// "���" �׼��� �������� �����ϰ� �ִ� ��쿡�� ����� �����մϴ�.
	}
}

// ����Ʈ �߰�. �̴ϸʿ� �����ֱ�
function OnAirShipTeleportList( String a_Param )
{	
	local int ID;
	local int FuelConsume;	
	local int X;
	local int Y;
	local int Z;
	
	
	ParseInt(a_Param, "ID", ID);
	ParseInt(a_Param, "FuelConsume", FuelConsume);	
	ParseInt(a_Param, "X", X);
	ParseInt(a_Param, "Y", Y);
	ParseInt(a_Param, "Z", Z);
	
	// �迭�� �߰��Ѵ�. 
	m_arrTelID.Insert(0,1);		m_arrTelID[0] = ID;
	m_arrAirportID.Insert(0,1);	m_arrAirportID[0] = m_airportID;
	m_arrFuel.Insert(0,1);		m_arrFuel[0] = FuelConsume;
	m_arrX.Insert(0,1);		m_arrX[0] = X;
	m_arrY.Insert(0,1);		m_arrY[0] = Y;
	m_arrZ.Insert(0,1);		m_arrZ[0] = Z;
	
	// ���� ���� ��ġ ǥ��
	SetLoc(ID);
	
	SelectLoc(ID, false);	// �⺻������ ���õ� ����. ���ʿ� ������ �����ؾ� �Ѵ�.
	
	if(ID == -1)	// Ƽ��Ʈ ��ġ�̱� ������ ������ -1 �� �־�� �Ѵ�. 
	{
		//���� ���� ����Ʈ ��ġ�� ������ ����.
		selectID = -1;
		SelectLoc(-1, true);	
	}
}

function OnMinimapRegionInfoBtnClick( String a_Param )
{
	local int ID;
	
	ParseInt(a_Param, "Index", ID);
	
	// ��� ����� �ؽ��ĸ� �����ش�.
	for(i =0; i<m_arrTelID.Length; i++)
	{
		UnSelectLoc( m_arrTelID[i]);	
	}
	
	if( ID < 9800)	
	{
		SelectLoc(ID, true);	// ��� ������Ʈ �Ѵ�.	//���⼭�� ������Ʈ��
	}
	else //����� Ŭ���Ǿ��� ���
	{
		SelectLoc(ID - FLAG_ID, true);	// ��� ������Ʈ �Ѵ�.	//���⼭�� ������Ʈ��
	}
	
	selectID = ID;	//���� ������ �ش� ���̵� �����Ѵ�.	
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnMyPos":
		OnBtnMyPos();
		break;
	case "btnGo":
		OnBtnGo();
		break;
	case "btnCancle":
		if(Me.isShowWindow()) Me.HideWindow();	//â�ݱ�
		Clear();
		SetMeCenter();
		break;
	}
}

// �� ��ġ ��ư Ŭ����
function OnBtnMyPos()
{
	SetMeCenter();	// �� ��ġ�� ����� �ϰ�
	
	// 0��¥�� �ڷ���Ʈ ��ġ�� �ڵ� �������ش�. 
}

// ��� ��ư�� ������ �� ������ �����Ѵٸ� ������ �Ѵ�.
function OnBtnGo()
{
	if(selectID != -72)
	{
		if(selectID >= 9000) selectID = selectID - 10000;
		class'VehicleAPI'.static.RequestExAirShipTeleport( selectID );
		if(Me.isShowWindow()) Me.HideWindow();	//â�ݱ�
		Clear();
		SetMeCenter();
	}
}

// �� ��ġ�� �߽ɿ� ����
function SetMeCenter()
{
	local vector loc;
	loc = GetPlayerPosition();
	
	FlightMap.AdjustMapView(loc);	// �� ��ġ�� �߽����δٰ� �Ű���
}

// ���� ������ �ڷ���Ʈ ���� ������Ʈ
function SelectLoc(int ID , bool isUpdate)
{	
	local int arrIdx;
	local int AirportID;
	local int FuelConsume;	
	local int X;
	local int Y;
	local int Z;
	
	local int AirPortNameID;
	local string DataforMap;
	
	arrIdx = FindArrIdxByID(ID);	
	if(arrIdx == -1 )
	{ 
		//debug("ERROR!! Array Index Error! -- SelectLoc");
		return; 
	}
	
	AirportID = m_arrAirportID[arrIdx];
	FuelConsume = m_arrFuel[arrIdx];
	X = m_arrX[arrIdx];
	Y = m_arrY[arrIdx];
	Z = m_arrZ[arrIdx];
	
	AirPortNameID = FindSystemStrByID( ID, AirportID);	// ���̵��� �ڷ���Ʈ ��ġ�� �̸��� �����´�.
	
	ParamAdd(DataforMap, "Index", String(ID + FLAG_ID));
	ParamAdd(DataforMap, "WorldX", string(X));
	ParamAdd(DataforMap, "WorldY", string(Y - 4500));

	ParamAdd(DataforMap, "BtnWidth", string(32));
	ParamAdd(DataforMap, "BtnHeight", string(32));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip", "");
	
	if(isUpdate == true)	// ������Ʈ�� ���� ��쿡�� ������Ʈ�� �Ѵ�.
	{
		ParamAdd(DataforMap, "BtnTexNormal", ICON_FLAG);
		ParamAdd(DataforMap, "BtnTexPushed", ICON_FLAG);
		ParamAdd(DataforMap, "BtnTexOver", ICON_FLAG );
		
		FlightMap.UpdateRegionInfo(ID + FLAG_ID  , DataforMap);

		// �ؽ�Ʈ�� ������ ������Ʈ �� ��쿡�� �Ѵ�.
		// �ý�Ʈ �ڽ� ����
		TargetTxt.SetText( "" $ GetSystemString( AirPortNameID ) );	
			
		// ���� �Ҹ� ��� ����	
		CostTxt.SetText( string(FuelConsume) $ " EP" );
	}
	else
	{
		ParamAdd(DataforMap, "BtnTexNormal", "");
		ParamAdd(DataforMap, "BtnTexPushed", "");
		ParamAdd(DataforMap, "BtnTexOver", "");
		
		FlightMap.AddRegionInfo(DataforMap);
	}
}

// ���� �ؽ��ĸ� �ʱ�ȭ���ش�.
function UnSelectLoc(int ID)
{	
	local int arrIdx;
	local int X;
	local int Y;
	local int Z;
	
	local string DataforMap;
	
	if(ID > FLAG_ID - 100)
	{
		arrIdx = FindArrIdxByID(ID - FLAG_ID);	
	}
	if(arrIdx == -1 )
	{ 
		//debug("ERROR!! Array Index Error! -- SelectLoc");
		return; 
	}
	
	X = m_arrX[arrIdx];
	Y = m_arrY[arrIdx];
	Z = m_arrZ[arrIdx];
	
	ParamAdd(DataforMap, "Index", String(ID + FLAG_ID));
	ParamAdd(DataforMap, "WorldX", string(X));
	ParamAdd(DataforMap, "WorldY", string(Y - 4500));

	ParamAdd(DataforMap, "BtnWidth", string(32));
	ParamAdd(DataforMap, "BtnHeight", string(32));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.EmptyBtn");
	ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.EmptyBtn");
	ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.EmptyBtn");
	ParamAdd(DataforMap, "Tooltip", "");
	FlightMap.UpdateRegionInfo(ID + FLAG_ID  , DataforMap);
}

// �ڷ���Ʈ ���� ����
function SetLoc(int ID)
{
	//���ᰡ ������ ��� �𽺿��̺� �ؽ��ķ� �ѷ��ش�. (���Ŀ� -_-);;
	
	local int arrIdx;
	local int AirportID;
	local int FuelConsume;	
	local int X;
	local int Y;
	local int Z;
	
	local string DataforMap;
	
	arrIdx = FindArrIdxByID(ID);	
	if(arrIdx == -1 )
	{ 
		//debug("ERROR!! Array Index Error! -- SetLoc");
		return; 
	}	
	AirportID = m_arrAirportID[arrIdx];
	FuelConsume = m_arrFuel[arrIdx];
	X = m_arrX[arrIdx];
	Y = m_arrY[arrIdx];
	Z = m_arrZ[arrIdx];

	
	ParamAdd(DataforMap, "Index", String(ID) );
	ParamAdd(DataforMap, "WorldX", string(X));
	ParamAdd(DataforMap, "WorldY", string(Y));
	ParamAdd(DataforMap, "BtnTexNormal", ICON_LOC);
	ParamAdd(DataforMap, "BtnTexPushed", ICON_LOC);
	ParamAdd(DataforMap, "BtnTexOver", ICON_LOC );
	ParamAdd(DataforMap, "BtnWidth", string(32));
	ParamAdd(DataforMap, "BtnHeight", string(32));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip", "");
	FlightMap.AddRegionInfo(DataforMap);	
}

function int FindArrIdxByID(int ID)
{
	local int Value;
	
	Value = -1;	//	 -1�� ���ж�°�
	
	for(i =0; i<m_arrTelID.Length; i++)
	{
		if(m_arrTelID[i] == ID ) return i;
	}
	
	return Value;	
}
defaultproperties
{
}
