class ItemControlWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle item1, item2, item3, item4, item5;
var TextureHandle tex5;


//var InventoryWnd script_inv;

function OnRegisterEvent() 
{
	
}

function OnLoad()
{
    InitHandle();
    OnRegisterEvent();
	//script_inv = InventoryWnd (GetScript("InventoryWnd"));
	Me.SetWindowSize( 164 , 42 );
}

function InitHandle() 
{
    Me = GetWindowHandle("ItemControlWnd");
    item1 = GetItemWindowHandle("ItemControlWnd.I_Item1");
    item2 = GetItemWindowHandle("ItemControlWnd.I_Item2");
    item3 = GetItemWindowHandle("ItemControlWnd.I_Item3");
    item4 = GetItemWindowHandle("ItemControlWnd.I_Item4");
    item5 = GetItemWindowHandle("ItemControlWnd.I_Item5");
    tex5 = GetTextureHandle("ItemControlWnd.over5");

}

/*function OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int index)
{
    local ItemInfo info;
    local string str1,str2,str3,str4,str5,str6;
	//local string test1,test2;

    a_hItemWindow.GetItem(index, info);
	
	class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( info.RefineryOp1, str1, str2, str3 );
	class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( info.RefineryOp2, str4, str5, str6);
	
	str4 = ReplaceText(str4, "\\n", "");
	
	//AddSystemMessageString("str4 - "$str4);
	
	//AddSystemMessageString("test1 - "$test1);
	
	AddSystemMessageString("RefineryOp1 - " @ info.RefineryOp1);
	AddSystemMessageString("RefineryOp2 - " @ info.RefineryOp2);
	
	//test1 = "Equip skill: Bestows on yourself the ability to re\nflect";
	//test2 = "Equip skill: Bestows on yourself the ability to re\\nflect";
	
	//if ( InStr( str4, test2 ) != -1 )
		//AddSystemMessageString("test2 - true");
	
	//AddSystemMessageString("str4 - "$str4);
	
	

   
}*/

function OnEvent(int Event_ID, String param) 
{
 
}

static final function string ReplaceText(coerce string Text, coerce string Replace, coerce string With)
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

defaultproperties
{
}
