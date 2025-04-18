class TaliWnd extends UICommonAPI;

const SLOTS_COUNT = 6;

var WindowHandle taliWndHandle;
var ItemWindowHandle tal[SLOTS_COUNT];
var TextureHandle tex[SLOTS_COUNT];
var int Counter;
var ItemID skillID[SLOTS_COUNT];
var string iconName[SLOTS_COUNT];
var string skillName[SLOTS_COUNT];

function OnRegisterEvent() 
{
    RegisterEvent(EV_SkillListStart);
    RegisterEvent(EV_SkillList);
}

function OnLoad() 
{
    InitHandle();
    OnRegisterEvent();

    tal[5].HideWindow();
    tal[4].HideWindow();
    tex[5].HideWindow();
    tex[4].HideWindow();
    taliWndHandle.SetWindowSize(156, 42);
    taliWndHandle.SetAnchor("FlightTransformCtrlWnd.FlightShortCut", "TopRight", "TopRight", -33, -41);
}

function InitHandle() 
{
    local int i;

    taliWndHandle = GetWindowHandle("TaliWnd");
    for (i = 0; i < SLOTS_COUNT; i++)
    {
    	tal[i] = GetItemWindowHandle("TaliWnd.T_Talisman" $ string(i));
    	tex[i] = GetTextureHandle("TaliWnd.over" $ string(i));
    }
}

function OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int index) 
{
    local ItemInfo info;

    a_hItemWindow.GetItem(index, info);
    
    UseSkill(info.ID, info.ItemSubType);
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int index) 
{
    local ItemInfo info;

    if (a_hItemWindow.GetItem(index, info)) 
    {
        RequestUseItem(info.ID);
    }
}

function OnEvent(int Event_ID, String param) 
{
    if (Event_ID == EV_SkillListStart)
        HandleSkillListStart();
    else if (Event_ID == EV_SkillList)
        HandleSkillList(param);
}

function HandleSkillListStart() 
{
    local int i;

    Counter = 0;
    for (i = 0; i < SLOTS_COUNT; i++)
    {
    	ClearItemID(skillID[i]);
    	iconName[i] = "";
    }
}

function HandleSkillList(string param) 
{
    local string name;
    
    ParseString(param, "Name", name);
    if (InStr(name, "Talisman") == -1)
        return;

    Counter++;
    if (Counter > 4)
    {
    	tal[5].ShowWindow();
    	tal[6].ShowWindow();
    	tex[5].ShowWindow();
    	tex[6].ShowWindow();
    	taliWndHandle.SetAnchor("FlightTransformCtrlWnd.FlightShortCut", "TopRight", "TopRight", 0, -41);
    	taliWndHandle.SetWindowSize(230, 42);
    }
    else
    {
    	tal[5].HideWindow();
    	tal[6].HideWindow();
    	tex[5].HideWindow();
    	tex[6].HideWindow();
    	taliWndHandle.SetAnchor("FlightTransformCtrlWnd.FlightShortCut", "TopRight", "TopRight", -33, -41);
    	taliWndHandle.SetWindowSize(159, 42);
    }
}
defaultproperties
{
}
