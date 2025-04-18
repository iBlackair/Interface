class DepthOfField extends UICommonAPI;

function OnRegisterEvent()
{
	RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_USER_CharacterSelectionChanged);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
}

function HandleStateChanged(string a_NewState)
{
	//debug("State"@a_NewState);
	switch(a_NewState)
	{
	case "LOGINSTATE":
	case "LOGINWAITSTATE":
	case "EULAMSGSTATE":
	case "CHINAWARNMSGSTATE":
	case "SERVERLISTSTATE":
	case "REPLAYSELECTSTATE":
	case "CARDKEYLOGINSTATE":
		class'GraphicAPI'.static.DoFResume();
		class'GraphicAPI'.static.DoFSetFocusDistance(300.f);
		class'GraphicAPI'.static.DoFSetStartDistance(300.f);
		class'GraphicAPI'.static.DoFSetEndDistance(9000.f);
		break;
	case "CHARACTERSELECTSTATE":
		class'GraphicAPI'.static.DoFResume();
		class'GraphicAPI'.static.DoFSetFocusDistance(300.f);
		class'GraphicAPI'.static.DoFSetStartDistance(300.f);
		class'GraphicAPI'.static.DoFSetEndDistance(5000.f);
		break;
	case "LOADINGSTATE":
		class'GraphicAPI'.static.DoFPause();
		break;
	case "GAMINGSTATE":
		class'GraphicAPI'.static.DoFResume();
		class'GraphicAPI'.static.DoFSetFocusPlayer();
		class'GraphicAPI'.static.DoFSetStartDistance(300.f);
		class'GraphicAPI'.static.DoFSetEndDistance(9000.f);
		break;
	default:
		class'GraphicAPI'.static.DoFResume();
		class'GraphicAPI'.static.DoFSetFocusDistance(300.f);
		class'GraphicAPI'.static.DoFSetStartDistance(300.f);
		class'GraphicAPI'.static.DoFSetEndDistance(2000.f);
	}
}

function HandleCharacterSelectionChanged(string a_Param)
{
	local int charIndex;

	if(ParseInt(a_Param, "CharIndex", charIndex))
	{
		if(GetUIState() == "CHARACTERCREATESTATE")
		{
			class'GraphicAPI'.static.DoFResume();
			class'GraphicAPI'.static.DoFSetFocusActor(GetCharacterSelectionActor(charIndex));
			class'GraphicAPI'.static.DoFSetStartDistance(300.f);
			class'GraphicAPI'.static.DoFSetEndDistance(3000.f);
		}
	}
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
	case EV_StateChanged:
		HandleStateChanged(a_Param);
		break;
	case EV_USER_CharacterSelectionChanged:
		HandleCharacterSelectionChanged(a_Param);
		break;
	}
}
defaultproperties
{
}
