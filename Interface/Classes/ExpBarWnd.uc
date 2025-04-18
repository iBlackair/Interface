//================================================================================
// ExpBarWnd.
//================================================================================

class ExpBarWnd extends UICommonAPI;

var WindowHandle Me, MenuWnd;
var StatusBarHandle EXPBar;


function OnRegisterEvent ()
{
  RegisterEvent(180);
}

function OnEvent (int a_EventID, string a_Param)
{
  switch (a_EventID)
  {
    case 180:
    UpdateUserInfo();
    break;
    default:
    break;
  }
}

/*function OnLButtonUp (WindowHandle a_WindowHandle, int X, int Y)
{
  switch (a_WindowHandle)
  {
    case Me:
    MenuWnd.SetFocus();
    break;
    default:
  }
}*/

function OnLoad ()
{
  if ( CREATE_ON_DEMAND == 0 )
  {
    OnRegisterEvent();
  }
  if ( CREATE_ON_DEMAND == 0 )
  {
    InitHandle();
  } else {
    InitHandleCOD();
  }
}

function InitHandle ()
{
  Me = GetHandle("ExpBarWnd");
  MenuWnd = GetHandle("MenuWnd");
  EXPBar = StatusBarHandle(GetHandle("ExpBarWnd.EXPBar"));
}

function InitHandleCOD ()
{
  Me = GetWindowHandle("ExpBarWnd");
  MenuWnd = GetWindowHandle("MenuWnd");
  EXPBar = GetStatusBarHandle("ExpBarWnd.EXPBar");
}

function UpdateUserInfo ()
{
  local UserInfo UserInfo;
  if ( GetPlayerInfo(UserInfo) )
  {
    EXPBar.SetPointExpPercentRate(UserInfo.fExpPercentRate);
  }
}
