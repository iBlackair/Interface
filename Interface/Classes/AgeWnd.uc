class AgeWnd extends UICommonAPI;

const TIMER_ID=148;
const TIMER_DELAY=5000;

const TIMER_ID2=149;
const TIMER_DELAY2=600000;

var WindowHandle Me;
var TextureHandle AgeTex;
var WindowHandle HelpHtmlWnd;
var WindowHandle m_hHelpHtmlWndAgeHelpWnd;
var TextureHandle m_hHelpHtmlWndAgeHelpWndAgeTex;

var string Texture15;
var string Texture18;
var string TextureFree;
var string HelpTexture15;
var string HelpTexture18;
var string HelpTextureFree;

var bool bBlock;

function OnRegisterEvent()
{
	RegisterEvent( EV_ServerAgeLimitChange );
}

function OnLoad()
{
	Initialize();
	Load();
	//Me.ShowWindow();
}

function Initialize()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "AgeWnd" );
		AgeTex = TextureHandle ( GetHandle( "AgeWnd.AgeTex" ) );
		HelpHtmlWnd = GetHandle( "HelpHtmlWnd" );

		m_hHelpHtmlWndAgeHelpWnd=GetHandle("HelpHtmlWnd.AgeHelpWnd");
		m_hHelpHtmlWndAgeHelpWndAgeTex=TextureHandle(GetHandle("HelpHtmlWnd.AgeHelpWnd.AgeTex"));
	}
	else
	{
		Me = GetWindowHandle( "AgeWnd" );
		AgeTex = GetTextureHandle( "AgeWnd.AgeTex" );
		HelpHtmlWnd = GetWindowHandle( "HelpHtmlWnd" );

		m_hHelpHtmlWndAgeHelpWnd=GetWindowHandle("HelpHtmlWnd.AgeHelpWnd");
		m_hHelpHtmlWndAgeHelpWndAgeTex=GetTextureHandle("HelpHtmlWnd.AgeHelpWnd.AgeTex");
	}

	
	bBlock = false;
}

function Load()
{
	Texture15 = "L2Font.Skins.kr_rated_15";
	Texture18 = "L2Font.Skins.kr_rated_18";
	TextureFree = "";
	HelpTexture15 = "L2Font.Skins.Help_Age_15";
	HelpTexture18 = "L2Font.Skins.Help_Age_18";
	HelpTextureFree = "";
}

//ó�� �����Ҷ�
function OnEnterState( name a_PrevStateName )
{
	if( a_PrevStateName == 'LoadingState' )
	{
		if(!bBlock) startAge();
	}
}


function startAge()
{
	// ���⼭ ���̵� �� �ؽ���
	//AgeTex.SetAlpha( 0 );
	Me.ShowWindow();
	AgeTex.ShowWindow();
	//AgeTex.SetAlpha( 255, 2.0f );
	Me.SetTimer(TIMER_ID,TIMER_DELAY);	//�ش� �ð��� ������ ���̵� �ƿ� �����ش�. 
	
	bBlock = true;	//���� ���� ���� ���´�. 
	Me.SetTimer(TIMER_ID2,TIMER_DELAY2);
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		Me.HideWindow();
		Me.KillTimer( TIMER_ID );
	}
	else if(TimerID == TIMER_ID2)	//Ÿ�̸Ӱ� �ٵǸ� ����� ���ش�. 
	{
		bBlock = false;
		Me.KillTimer( TIMER_ID2 );
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	local int ServerAgeLimitInt;
	local int nWndWidth;
	local int nWndHeight;	// ������ ������ �ޱ� ����
	local EServerAgeLimit ServerAgeLimit;

	if( a_EventID == EV_ServerAgeLimitChange )
	{
		if( ParseInt( a_Param, "ServerAgeLimit", ServerAgeLimitInt ) )
		{
			ServerAgeLimit = EServerAgeLimit( ServerAgeLimitInt );
			switch( ServerAgeLimit )	//������ �ؽ��ĸ� �������ش�. 
			{
			case SERVER_AGE_LIMIT_15:	
				//debug( "Texture15=" $ HelpTexture15 );
				AgeTex.SetTexture(Texture15);
				m_hHelpHtmlWndAgeHelpWndAgeTex.SetTexture(HelpTexture15);
				HelpHtmlWnd.GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;; Height�� ���
				HelpHtmlWnd.SetWindowSize(nWndWidth, 501);	// ���̸� 82 �÷��ش�. (���ǥ�� �ؽ�Ʈ�� ����)
				//class'UIAPI_TEXTURECTRL'.static.SetTexture( "HelpHtmlWnd.AgeHelpWnd", LoadingTexture15 );
				break;
			case SERVER_AGE_LIMIT_18:
				//debug( "Texture18=" $ HelpTexture18 );
				AgeTex.SetTexture(Texture18);
				HelpHtmlWnd.GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;; Height�� ���
				HelpHtmlWnd.SetWindowSize(nWndWidth, 501);	// ���̸� 82 �÷��ش�. (���ǥ�� �ؽ�Ʈ�� ����)
				m_hHelpHtmlWndAgeHelpWndAgeTex.SetTexture(HelpTexture18);
				break;
			case SERVER_AGE_LIMIT_Free:
				//debug( "TextureFree=" $ TextureFree );
			default:
				AgeTex.SetTexture(TextureFree);
				AgeTex.HideWindow();
				m_hHelpHtmlWndAgeHelpWnd.HideWindow();
				break;
			}
		}
	}
}
defaultproperties
{
}
