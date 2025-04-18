class L2Util extends UICommonAPI;


var Color White;
var Color Yellow;
var Color Blue;
var Color BrightWhite;
var Color Gold;


enum ETreeItemTextType
{
	COLOR_DEFAULT,
	COLOR_GRAY,
	COLOR_GOLD,
	COLOR_RED,
	COLOR_YELLOW
};

var CustomTooltip TooltipText;
var DrawItemInfo TooltipInfo;

enum ETooltipTextType
{
	COLOR_DEFAULT,
	COLOR_GRAY,
	COLOR_GOLD
};


delegate bool myDelegate(bool bFirst, string str);



function OnLoad()
{
	initColor();
}

function initColor()
{
	BrightWhite.R = 255;
	BrightWhite.G = 255;
	BrightWhite.B = 255;	

	White.R = 170;
	White.G = 170;
	White.B = 170;

	Yellow.R = 235;
	Yellow.G = 205;
	Yellow.B = 0;

	Blue.R = 102;
	Blue.G = 150;
	Blue.B = 253;

	Gold.R = 176;
	Gold.G = 153;
	Gold.B  = 121;
}


function animTexturePlay(string controlPath, string texturePath,int playLoopCount)
{	
	GetAnimTextureHandle(controlPath).SetTexture(texturePath);
	GetAnimTextureHandle(controlPath).ShowWindow();
	GetAnimTextureHandle(controlPath).SetLoopCount(playLoopCount);
	GetAnimTextureHandle(controlPath).Stop();
	GetAnimTextureHandle(controlPath).Play();
}




function TreeInsertRootNode( string TreeName, string NodeName, string ParentName, optional int offSetX, optional int offSetY )
{
	local XMLTreeNodeInfo infNode;
	
	infNode.strName = NodeName;	
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;

	class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}


function TreeInsertExpandBtnNode( string TreeName, string NodeName, string ParentName, optional int nTexBtnWidth, optional int nTexBtnHeight, 
									optional string strTexBtnExpand, optional string strTexBtnExpand_Over, optional string strTexBtnCollapse, optional string strTexBtnCollapse_Over,
									optional int offSetX, optional int offSetY )
{
	local XMLTreeNodeInfo infNode;

	if( nTexBtnWidth == 0 ) nTexBtnWidth = 15;
	if( nTexBtnHeight == 0 ) nTexBtnHeight = 15;
	if( strTexBtnExpand == "" ) strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
	if( strTexBtnExpand_Over == "" ) strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
	if( strTexBtnCollapse == "" ) strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
	if( strTexBtnCollapse_Over == "" ) strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";

	infNode.strName = NodeName;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = nTexBtnWidth;
	infNode.nTexBtnHeight = nTexBtnHeight;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.strTexBtnExpand = strTexBtnExpand;
	infNode.strTexBtnExpand_Over = strTexBtnExpand_Over;
	infNode.strTexBtnCollapse = strTexBtnCollapse;
	infNode.strTexBtnCollapse_Over = strTexBtnCollapse_Over;

	class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}


function string TreeInsertItemTooltipSimpleNode( string TreeName, string NodeName, string ParentName, 
									int nTexExpandedOffSetX, int nTexExpandedOffSetY, 
									int nTexExpandedHeight, int nTexExpandedRightWidth, 
									int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight,									
									optional string TooltipSimpleText, optional string strTexExpandedLeft, optional int offSetX, optional int offSetY )
{
	local XMLTreeNodeInfo infNode;
	
	if( TooltipSimpleText != "" ) infNode.Tooltip = MakeTooltipSimpleText( TooltipSimpleText );
	if( strTexExpandedLeft == "" ) strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	infNode.strName = NodeName;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = true;
	
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;		
	infNode.nTexExpandedHeight = nTexExpandedHeight;		
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;		
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth; 		
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;

	return class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

function string TreeInsertItemTooltipNode( string TreeName, string NodeName, string ParentName, 
									int nTexExpandedOffSetX, int nTexExpandedOffSetY, 
									int nTexExpandedHeight, int nTexExpandedRightWidth, 
									int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight,									
									CustomTooltip TooltipText, optional string strTexExpandedLeft, optional int offSetX, optional int offSetY )
{
	//트리 노드 정보
	local XMLTreeNodeInfo infNode;	
	
	if( strTexExpandedLeft == "" ) strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	infNode.strName = NodeName;
	infNode.Tooltip = TooltipText;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = true;
	//Expand되었을때의 BackTexture설정
	//스트레치로 그리기 때문에 ExpandedWidth는 없다. 끝에서 -2만큼 배경을 그린다.
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;		
	infNode.nTexExpandedHeight = nTexExpandedHeight;		
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;		
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth; 		
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;

	return class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

function string TreeInsertItemNode( string TreeName, string NodeName, string ParentName, optional bool bFollowCursor, optional int offSetX, optional int offSetY )
{
	//트리 노드 정보
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;
	infNode.Tooltip = TooltipText;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = bFollowCursor;

	return class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}


function TreeInsertTextNodeItem( string TreeName, string NodeName, string ItemName, optional int offSetX, optional int offSetY, optional ETreeItemTextType E, 
									optional bool OneLine, optional bool bLineBreak, optional int reserved )
{
	//트리 노드아이템 정보
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = OneLine;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	
	infNodeItem = setTreeTextColor( E, infNodeItem );

	if( reserved != 0 )
	{
		infNodeItem.nReserved = reserved;
	}

	class'UIAPI_TREECTRL'.static.InsertNodeItem( TreeName, NodeName, infNodeItem );
}


function TreeInsertTextMultiNodeItem( string TreeName, string NodeName, string ItemName, optional int offSetX, optional int offSetY, 
										optional int MaxHeight, optional ETreeItemTextType E, optional bool bLineBreak, optional int reserved, optional int reserved2 )
{
	//트리 노드아이템 정보
	local XMLTreeNodeItemInfo infNodeItem;

	if( MaxHeight == 0 ) MaxHeight = 38;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = false;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	infNodeItem.t_nMaxHeight = MaxHeight;
	infNodeItem.t_vAlign = TVA_Middle;
	
	infNodeItem = setTreeTextColor( E, infNodeItem );

	if( reserved != 0 )
	{
		infNodeItem.nReserved = reserved;
	}
	
	infNodeItem.nReserved2 = 0;
	if( reserved2 > 0 )
	{
		infNodeItem.nReserved2 = reserved2;
	}

	class'UIAPI_TREECTRL'.static.InsertNodeItem( TreeName, NodeName, infNodeItem );
}


function XMLTreeNodeItemInfo setTreeTextColor( ETreeItemTextType E, XMLTreeNodeItemInfo infNodeItem )
{
	switch( E )
	{
		case ETreeItemTextType.COLOR_DEFAULT:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 255;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;
		
		case ETreeItemTextType.COLOR_GRAY:
			infNodeItem.t_color.R = 163;
			infNodeItem.t_color.G = 163;
			infNodeItem.t_color.B = 163;
			infNodeItem.t_color.A = 255;
			break;

		case ETreeItemTextType.COLOR_GOLD:
			infNodeItem.t_color.R = 176;
			infNodeItem.t_color.G = 155;
			infNodeItem.t_color.B = 121;
			infNodeItem.t_color.A = 255;
			break;
		case ETreeItemTextType.COLOR_RED:
			infNodeItem.t_color.R = 250;
			infNodeItem.t_color.G = 50;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
		case ETreeItemTextType.COLOR_YELLOW:
			infNodeItem.t_color.R = 240;
			infNodeItem.t_color.G = 214;
			infNodeItem.t_color.B = 54;
			infNodeItem.t_color.A = 255;
			break;
	}
	return infNodeItem;
}


function TreeInsertTextureNodeItem( string TreeName, string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int offSetX, optional int offSetY, 
										optional bool OneLine, optional bool bLineBreak, optional int TextureUHeight )
{
	//트리 노드아이템 정보
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.t_bDrawOneLine = OneLine;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	infNodeItem.u_nTextureUHeight = TextureUHeight;
	infNodeItem.u_nTextureWidth = TextureWidth;
	infNodeItem.u_nTextureHeight = TextureHeight;
	infNodeItem.u_strTexture = TextureName;

	class'UIAPI_TREECTRL'.static.InsertNodeItem( TreeName, NodeName, infNodeItem );
} 


function TreeInsertBlankNodeItem( string TreeName, string NodeName )
{
	//트리 노드아이템 정보
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.bStopMouseFocus = true;
	infNodeItem.b_nHeight = 4;
	class'UIAPI_TREECTRL'.static.InsertNodeItem( TreeName, NodeName, infNodeItem );
}


function TreeClear( string str )
{
	class'UIAPI_TREECTRL'.static.Clear( str );
}


function setCustomTooltip( CustomTooltip T )
{
	TooltipText = T;
}

function CustomTooltip getCustomTooltip()
{
	return TooltipText;
}

function ToopTipMinWidth( int width )
{
	TooltipText.MinimumWidth = width;
}

function ToopTipInsertText( string Text, optional bool OneLine, optional bool bLineBreak,optional ETooltipTextType E, optional int offSetX, optional int offSetY )
{
	if( Len( Text ) == 0 ) return;

	StartItem();
	TooltipInfo.eType = DIT_TEXT;
	TooltipInfo.t_bDrawOneLine = OneLine;
	TooltipInfo.bLineBreak = bLineBreak;
	TooltipInfo.t_strText = Text;
	TooltipInfo.nOffSetX = offSetX;
	TooltipInfo.nOffSetY = offSetY;
	TooltipInfo = setToopTipTextColor( E, TooltipInfo );
	EndItem();
}

/**
 *  툴팁에 Text 아이템의 글씨 색상
 */
function DrawItemInfo setToopTipTextColor( ETooltipTextType E, DrawItemInfo info )
{
	switch( E )
	{
		case ETooltipTextType.COLOR_DEFAULT:
			info.t_color.R = 255;
			info.t_color.G = 255;
			info.t_color.B = 255;
			info.t_color.A = 255;
			break;
		
		case ETooltipTextType.COLOR_GRAY:
			info.t_color.R = 163;
			info.t_color.G = 163;
			info.t_color.B = 163;
			info.t_color.A = 255;
			break;

		case ETooltipTextType.COLOR_GOLD:
			info.t_color.R = 176;
			info.t_color.G = 155;
			info.t_color.B = 121;
			info.t_color.A = 255;
			break;		
	}
	return info;
}

function TwoWordCombineColon( string word1, string word2, optional ETooltipTextType E1, optional ETooltipTextType E2, optional bool bLineBreak, optional int offSetX, optional int offSetY )
{
	ToopTipInsertText( word1, false, bLineBreak, E1, offSetX, offSetY );
	ToopTipInsertText( " : ", false, false, ETooltipTextType.COLOR_GRAY, offSetX, offSetY );
	ToopTipInsertText( word2, false, false, E2, offSetX, offSetY );

}

function ToopTipInsertTexture( string Texture, optional bool OneLine, optional bool bLineBreak, optional int offSetX, optional int offSetY )
{
	StartItem();
	TooltipInfo.eType = DIT_TEXTURE;
	TooltipInfo.t_bDrawOneLine = OneLine;
	TooltipInfo.bLineBreak = bLineBreak;
	TooltipInfo.u_nTextureWidth = 16;
	TooltipInfo.u_nTextureHeight = 16;
	TooltipInfo.nOffSetX = offSetX;
	TooltipInfo.nOffSetY = offSetY;
	TooltipInfo.u_nTextureUWidth = 32;
	TooltipInfo.u_nTextureUHeight = 32;

	TooltipInfo.u_strTexture = Texture;
	EndItem();
}


function TooltipInsertItemBlank( int Height )
{
	StartItem();
	TooltipInfo.eType = DIT_BLANK;
	TooltipInfo.b_nHeight = Height;
	EndItem();
}


function TooltipInsertItemLine()
{
	StartItem();
	TooltipInfo.eType = DIT_SPLITLINE;
	TooltipInfo.u_nTextureWidth = TooltipText.MinimumWidth;			
	TooltipInfo.u_nTextureHeight = 1;
	TooltipInfo.u_strTexture ="L2ui_ch3.tooltip_line";
	EndItem();
}

function StartItem()
{
	local DrawItemInfo infoClear;
	TooltipInfo = infoClear;
}

function EndItem()
{
	TooltipText.DrawList.Length = TooltipText.DrawList.Length + 1;
	TooltipText.DrawList[ TooltipText.DrawList.Length - 1 ] = TooltipInfo;
}

function String TimeNumberToString( int time )
{
	local int Min;
	local int Sec;
	
	local string strTime;
	local string SecString;

	Min = time / 60;
	Sec = time % 60;

	SecString = string( Sec );

	if(Sec < 10)
	{
		SecString = "0" $ string( Sec );
	}

	if( time > 60 )
	{
		strTime = "0" $string( Min ) $ ":" $ SecString;
	}
	else
	{
		strTime = "00:" $ SecString;
	}

	return strTime;
}

function String TimeNumberToHangulHourMin( int time )
{
	local int Hour;
	local int Min;
	local int Sec;	

	local string strMin;

	Min = time / 60;
	Hour = Min / 60;
	Min = Min % 60;
	Sec = time % 60;	

	strMin = string(Min);

	if( Min < 10 )
	{
		strMin = "0"$string(Min);
	}

	return MakeFullSystemMsg( GetSystemMessage(3304), string(Hour), strMin );
}


function string MakeTimeString( float Time1, optional float Time2 )
{
	local int i;
	local float Time;
	local string strTime;
	local array<string>	arrSplit;
	
	if( Time2 != 0 )
	{
		Time = Time1+ Time2;		
	}
	else
	{
		Time = Time1;
	}

	strTime = string( Time );

	for( i = 0 ; i < Len(strTime) ; i++ )
	{
		if( Right( strTime, 1 ) == "0" )
		{
			strTime = Left( strTime, Len(strTime) - 1 );
			
		}
		else if( Right( strTime, 1 ) == "." )
		{
			break;
		}
	}		
	
	Split( strTime, ".", arrSplit);

	if( Len( arrSplit[1]) == 0 )
	{
		return arrSplit[0] $ GetSystemString(2001);
	}

	return strTime $ GetSystemString(2001);
}



function test(int a, int b, optional int x, optional string str)
{
	if (x == 0)
	{
		Debug("영이래!");
	}

	if (str =="")
	{
		Debug("스트링 꽝!");
	}
	
}




function int ctrlListSearchByName (ListCtrlHandle listCtrl, string name)
{
	// parse var
	local LVDataRecord record;
	local int i, nReturn;

	nReturn = -1;

	for (i = 0; i < listCtrl.GetRecordCount(); i++)
	{
		listCtrl.GetRec(i, record);
		if (record.LVDataList[0].szData == name)
		{
			nReturn = i;
			break;
		}
	}
	return nReturn;
}


function LVDataRecord getListSelectedRecord(ListCtrlHandle list, int index)
{	
	local LVDataRecord record;

	list.SetSelectedIndex(index, true);
	list.GetRec(index, record);

	return record;
}


function arrayShuffleInt(out array<int> tempArray)
{
	local int i, ran;
	local array<int> changeArray;

	changeArray = tempArray;

	tempArray.Remove(0, tempArray.Length);

	for (i = 0; i < 10; i++)
	{
		ran = rand(changeArray.Length);
		
		tempArray[i] = changeArray[ran];
		changeArray.Remove(ran, 1);
	}
}
defaultproperties
{
}
