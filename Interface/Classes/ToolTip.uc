class Tooltip extends UICommonAPI;

const TOOLTIP_MINIMUM_WIDTH = 144;
const TOOLTIP_SETITEM_MAX = 3;

const ATTRIBUTE_FIRE 	= 0;
const ATTRIBUTE_WATER 	= 1;
const ATTRIBUTE_WIND 	= 2;
const ATTRIBUTE_EARTH 	= 3;
const ATTRIBUTE_HOLY 	= 4;
const ATTRIBUTE_UNHOLY 	= 5;

var CustomTooltip m_Tooltip;
var DrawItemInfo m_Info;

var Array<int> AttackAttLevel;
var Array<int> AttackAttCurrValue;
var Array<int> AttackAttMaxValue; //��� ���� �Ӽ��� ����, ���緹�������� ��, ���緹�������� �ִ밪�� ���⿡ �����Ѵ�.

var Array<int> DefAttLevel;
var Array<int> DefAttCurrValue;
var Array<int> DefAttMaxValue; //��� ��� �Ӽ��� ����, ���緹�������� ��, ���緹�������� �ִ밪�� ���⿡ �����Ѵ�.

var int NowAttrLv;
var int NowMaxValue;
var int NowValue;

var bool BoolSelect;

function OnRegisterEvent()
{
	RegisterEvent( EV_RequestTooltipInfo );
}

function OnLoad()
{
	BoolSelect = true;	// ���� ���� �ѱ�/���� �⺻���� �ѱ��(TTP#41925) 2010.8.23 - winkey

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
}

function OnEvent(int Event_ID, string param)
{
	switch( Event_ID )
	{
	case EV_RequestTooltipInfo:
		//debug("�����̺�Ʈ �Ѿ����");
		HandleRequestTooltipInfo(param);
		break;
	}
}

function setBoolSelect( bool b )
{
	BoolSelect = b;
}

function HandleRequestTooltipInfo(string param)
{
	local String TooltipType;
	local int SourceType;
	local ETooltipSourceType eSourceType;
	
	ClearTooltip();
	
	if (!ParseString(param, "TooltipType", TooltipType))
		return;
		
	if (!ParseInt(param, "SourceType", SourceType))
		return;
	
	eSourceType = ETooltipSourceType(SourceType);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////// Normal Tooltip /////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//debug("TooltipŸ��:"$TooltipType);
	if (TooltipType == "Text")
	{
		ReturnTooltip_NTT_TEXT(param, eSourceType, false);
	}
	else if (TooltipType == "Description")
	{
		ReturnTooltip_NTT_TEXT(param, eSourceType, true);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////// ItemWnd Tooltip ////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	else if (TooltipType == "Action")
	{
		ReturnTooltip_NTT_ACTION(param, eSourceType);
	}
	else if (TooltipType == "Skill")
	{
		ReturnTooltip_NTT_SKILL(param, eSourceType);
	}
	else if (TooltipType == "NormalItem")
	{
		ReturnTooltip_NTT_NORMALITEM(param, eSourceType);
	}
	else if (TooltipType == "Shortcut")
	{
		ReturnTooltip_NTT_SHORTCUT(param, eSourceType);
	}
	else if (TooltipType == "AbnormalStatus")
	{
		ReturnTooltip_NTT_ABNORMALSTATUS(param, eSourceType);
	}
	else if (TooltipType == "RecipeManufacture")
	{
		ReturnTooltip_NTT_RECIPE_MANUFACTURE(param, eSourceType);
	}
	else if (TooltipType == "Recipe")
	{
		ReturnTooltip_NTT_RECIPE(param, eSourceType, false);
	}
	else if (TooltipType == "RecipePrice")
	{
		ReturnTooltip_NTT_RECIPE(param, eSourceType, true);
	}
	else if (TooltipType == "Inventory"
			|| TooltipType == "InventoryPrice1"
			|| TooltipType == "InventoryPrice2"
			|| TooltipType == "InventoryPrice1HideEnchant"
			|| TooltipType == "InventoryPrice1HideEnchantStackable"
			|| TooltipType == "InventoryPrice2PrivateShop"
			|| TooltipType == "InventoryWithIcon"
			|| TooltipType == "InventoryPawnViewer")		// PawnViewer�� �߰� - lancelot 2007. 10. 16.
	{
		//~ debug("���������ּ���.");
		ReturnTooltip_NTT_ITEM(param, TooltipType, eSourceType);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////// ListCtrl Tooltip ///////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//���� ����(2010.02.22 ~ 03.08) �Ϸ�
	else if ( TooltipType == "RoomList" )
	{
		ReturnTooltip_NTT_ROOMLIST(param, eSourceType);
	}	
	else if ( TooltipType == "UserList" )
	{
		ReturnTooltip_NTT_USERLIST(param, eSourceType);
	}
	else if (TooltipType == "PartyMatch")
	{
		ReturnTooltip_NTT_PARTYMATCH(param, eSourceType);
	}
	else if (TooltipType == "UnionList")
	{
		ReturnTooltip_NTT_UNIONLIST(param, eSourceType);
	}
	else if (TooltipType == "QuestInfo")
	{
		ReturnTooltip_NTT_QUESTINFO(param, eSourceType);
	}
	else if (TooltipType == "QuestList")
	{
		ReturnTooltip_NTT_QUESTLIST(param, eSourceType);
	}
	else if (TooltipType == "RaidList")
	{
		ReturnTooltip_NTT_RAIDLIST(param, eSourceType);
	}
	else if (TooltipType == "ClanInfo")
	{
		ReturnTooltip_NTT_CLANINFO(param, eSourceType);
	}
	else if (TooltipType == "RadarInfo")//by Merc
	{
		ReturnTooltip_NTT_RADARINFO(param, eSourceType);
	}
	//���� ����( 10.03.30 ) �Ϸ�
	//�����Կ� ���� �߰�.
	else if (TooltipType == "PostInfo")
	{
		ReturnTooltip_NTT_POSTINFO(param, eSourceType);
	}
	/////////////////////////////////////////////////////
	// MANOR
	else if (TooltipType == "ManorSeedInfo"
			|| TooltipType == "ManorCropInfo"
			|| TooltipType == "ManorSeedSetting"
			|| TooltipType == "ManorCropSetting"
			|| TooltipType == "ManorDefaultInfo"
			|| TooltipType == "ManorCropSell")
	{
		ReturnTooltip_NTT_MANOR(param, TooltipType, eSourceType);
	}
	// [����Ʈ ������ ���� �߰�]
	else if (TooltipType == "QuestItem")
	{
		ReturnTooltip_NTT_QUESTREWARDS(param, eSourceType);
	}
}

function bool IsEnchantableItem(EItemParamType Type)
{
	return (Type == ITEMP_WEAPON || Type == ITEMP_ARMOR || Type == ITEMP_ACCESSARY || Type == ITEMP_SHIELD);
}

function ClearTooltip()
{
	m_Tooltip.SimpleLineCount = 0;
	m_Tooltip.MinimumWidth = 0;
	m_Tooltip.DrawList.Remove(0, m_Tooltip.DrawList.Length);
}

function StartItem()
{
	local DrawItemInfo infoClear;
	m_Info = infoClear;
}

function EndItem()
{
	m_Tooltip.DrawList.Length = m_Tooltip.DrawList.Length + 1;
	m_Tooltip.DrawList[m_Tooltip.DrawList.Length-1] = m_Info;
}

/////////////////////////////////////////////////////////////////////////////////
// TEXT
function ReturnTooltip_NTT_TEXT(string param, ETooltipSourceType eSourceType, bool bDesc)
{
	local string strText;
	local int ID;
	
	if (eSourceType == NTST_TEXT)
	{
		if (ParseString( param, "Text", strText))
		{
			if (Len(strText)>0)
			{
				if (bDesc)
				{
					m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
					
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_color.R = 178;
					m_Info.t_color.G = 190;
					m_Info.t_color.B = 207;
					m_Info.t_color.A = 255;
					m_Info.t_strText = strText;
					EndItem();
				}
				else
				{
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = strText;
					EndItem();	
				}
			}
		}
		else if (ParseInt( param, "ID", ID))
		{
			if (ID>0)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_ID = ID;
				EndItem();
			}
		}
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// INVENTORY Etc
function ReturnTooltip_NTT_ITEM(string param, String TooltipType, ETooltipSourceType eSourceType)
{
	local ItemInfo Item;
	
	local EItemType eItemType;
	local EEtcItemType eEtcItemType;
	
	local bool bLargeWidth;
	local string SlotString;
	local string strTmp;
	local int nTmp;
	local int idx;
	
	//����ȿ��
	local string ItemName;
	local int Quality;
	local int ColorR;
	local int ColorG;
	local int ColorB;
	local string strDesc1;
	local string strDesc2;
	local string strDesc3;
	
	// ������ ������
	local int ItemNameClass;
	
	//��Ʈ������
	//~ local array<ItemID> arrItemID;
	local int SetID;
	//~ local int SetID2;
	
	//�Ƶ����о��ֱ�
	local string strAdena;
	local string strAdenaComma;
	local color	 AdenaColor;
	
	local ItemID tmpItemID;

	if (eSourceType == NTST_ITEM)
	{
		ParamToItemInfo(param, Item);
		
		eItemType = EItemType(Item.ItemType);
		eEtcItemType = EEtcItemType(Item.ItemSubType);
		
		//������ ǥ��
		if (TooltipType == "InventoryWithIcon")
		{
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.u_nTextureWidth = 32;
			m_Info.u_nTextureHeight = 32;
			m_Info.u_strTexture = Item.IconName;
			EndItem();
			
			AddTooltipItemBlank(4);
		}
		
		//������ �̸� ���
		ItemName = class'UIDATA_ITEM'.static.GetRefineryItemName( Item.Name, Item.RefineryOp1, Item.RefineryOp2 );
		
		ItemNameClass = class'UIDATA_ITEM'.static.GetItemNameClass( Item.ID);
		
		//branch
		AddPrimeItemSymbol(Item);
		//end of branch
		
		//��þƮ ex) "+10"
		if (TooltipType != "InventoryPrice1HideEnchant"
			&& TooltipType != "InventoryPrice1HideEnchantStackable")
			AddTooltipItemEnchant(Item);
		
		//������ �̸�
		AddTooltipItemName(ItemName, Item, ItemNameClass);
		
		//Grade Mark
		AddTooltipItemGrade(Item);
		
		//������ ����
		if (TooltipType != "InventoryPrice1HideEnchantStackable")
		{
			// 2009 10. 15
			// ����Ʈ ���� ������ Ÿ���̸� ������ ������ ǥ�� ���� �ʴ´�.
			if (TooltipType != "QuestReward")
			{
				AddTooltipItemCount(Item);
			}
		}
			
		//�������� �Ƶ�����, �о��ֱ� ��Ʈ��
		if (IsAdena(Item.ID))
		{
			//SimpleTooltip�� �о��ֱ⽺Ʈ������ �����ش�.
			m_Tooltip.SimpleLineCount = 2;
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_strText = "(" $ ConvertNumToText(Int64ToString(Item.ItemNum)) $ ")";
			EndItem();
		}
		
		//InventoryPrice1 Ÿ��
		if (TooltipType == "InventoryPrice1"
			|| TooltipType == "InventoryPrice1HideEnchant"
			|| TooltipType == "InventoryPrice1HideEnchantStackable")
		{
			strAdena = Int64ToString(Item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			
			//���� : xxx,xxx,xxx
			AddTooltipItemOption(322, strAdenaComma $ " ", true, true, false);
			SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
			
			//"�Ƶ���"
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color = AdenaColor;
			m_Info.t_ID= 469;
			EndItem();
			
			//SimpleTooltip�� ���ݱ��� �����ش�.
			m_Tooltip.SimpleLineCount = 2;
			
			//�о��ֱ� ��Ʈ��
			if (Item.Price>IntToInt64(0))
			{
				m_Tooltip.SimpleLineCount = 3;
				AddTooltipItemOption(0, "(" $ ConvertNumToText(strAdena) $ ")", false, true, false);
				SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
			}
		}
		
		//InventoryPrice2 Ÿ��
		if (TooltipType == "InventoryPrice2"
			|| TooltipType == "InventoryPrice2PrivateShop")
		{
			strAdena = Int64ToString(Item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			
			//���� : 1����
			AddTooltipItemOption2(322, 468, true, true, false);
			SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
			
			//"xxx,xxx,xxx "
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color = AdenaColor;
			m_Info.t_strText = " " $ strAdenaComma $ " ";
			EndItem();
			
			//"�Ƶ���"
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color = AdenaColor;
			m_Info.t_ID= 469;
			EndItem();
			
			//SimpleTooltip�� ���ݱ��� �����ش�.
			m_Tooltip.SimpleLineCount = 2;
			
			//�о��ֱ� ��Ʈ��
			if (Item.Price>IntToInt64(0))
			{
				m_Tooltip.SimpleLineCount = 3;
				
				//"("
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = 6;
				m_Info.bLineBreak = true;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color = AdenaColor;
				m_Info.t_strText = "(";
				EndItem();
				
				//"1����"
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = 6;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color = AdenaColor;
				m_Info.t_ID = 468;
				EndItem();
				
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = 6;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color = AdenaColor;
				m_Info.t_strText = " " $ ConvertNumToText(strAdena) $ ")";
				EndItem();
			}
		}
		
		//InventoryPrice2PrivateShop Ÿ��
		if (TooltipType == "InventoryPrice2PrivateShop")
		{
			if (IsStackableItem(Item.ConsumeType) && Item.Reserved64 > IntToInt64(0))
			{
				//"���Ű��� : xx"
				AddTooltipItemOption(808, Int64ToString(Item.Reserved64), true, true, false);
			}
		}

		/////////////////////////////////////////////////////////////////////////////////////////
		// �����ۿ� ���� ���� ����
		
		SlotString = GetSlotTypeString(Item.ItemType, Item.SlotBitType, Item.ArmorType);
		
		switch (eItemType)
		{
			
		// 1. WEAPON
		case ITEM_WEAPON:
			bLargeWidth = true;
			
			//Slot Type
			strTmp = GetWeaponTypeString(Item.WeaponType);
			if (Len(strTmp)>0)
			{
				AddTooltipItemOption(0, strTmp $ " / " $ SlotString, false, true, false);
			}
			
			//�����
			AddTooltipItemBlank(12);
			
			//"[���� ����]"
			AddTooltipItemOption(1489, "", true, false, false);
			SetTooltipItemColor(255, 255, 255, 0);
			
			//Physical Damage
			AddTooltipItemOption(94, String(GetPhysicalDamage(Item.WeaponType, Item.SlotBitType, Item.CrystalType, Item.Enchanted, Item.PhysicalDamage)), true, true, false);
			
			//Masical Damage
			AddTooltipItemOption(98, String(GetMagicalDamage(Item.WeaponType, Item.SlotBitType, Item.CrystalType, Item.Enchanted, Item.MagicalDamage)), true, true, false);
			
			//Attack Speed
			AddTooltipItemOption(111, GetAttackSpeedString(Item.AttackSpeed), true, true, false);
			
			//SoulShot Count
			if (Item.SoulshotCount>0)
			{
				AddTooltipItemOption(404, "X " $ Item.SoulshotCount, true, true, false);
			}
			
			//SpiritShot Count
			if (Item.SpiritShotCount>0)
			{
				AddTooltipItemOption(496, "X " $ Item.SpiritshotCount, true, true, false);
			}
			
			//Weight
			if (Item.Weight==0)
				AddTooltipItemOption(52, " 0 ", true, true, false);
			else
				AddTooltipItemOption(52, String(Item.Weight), true, true, false);
			//AddTooltipItemOption(52, String(Item.Weight), true, true, false);
			
			//MP Consume
			if (Item.MpConsume != 0)
			{
				AddTooltipItemOption(320, String(Item.MpConsume), true, true, false);
			}
			
			//����ȿ��
			if (Item.RefineryOp1 != 0 || Item.RefineryOp2 != 0)
			{
				//�����
				AddTooltipItemBlank(12);
				
				//"[����ȿ��]"
				AddTooltipItemOption(1490, "", true, false, false);
				SetTooltipItemColor(255, 255, 255, 0);
				
				//�÷��� ���
				if (Item.RefineryOp2 != 0)
				{
					Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality( Item.RefineryOp2 );
					GetRefineryColor(Quality, ColorR, ColorG, ColorB);
				}
				
				if (Item.RefineryOp1 != 0)
				{
					strDesc1 = "";
					strDesc2 = "";
					strDesc3 = "";
					if (class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Item.RefineryOp1, strDesc1, strDesc2, strDesc3 ))
					{	
						if (Len(strDesc1)>0)
						{
							AddTooltipItemOption(0, strDesc1, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
						if (Len(strDesc2)>0)
						{
							AddTooltipItemOption(0, strDesc2, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
						if (Len(strDesc3)>0)
						{
							AddTooltipItemOption(0, strDesc3, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
					}
				}	
				
				if (Item.RefineryOp2 != 0)
				{
					strDesc1 = "";
					strDesc2 = "";
					strDesc3 = "";
					if (class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Item.RefineryOp2, strDesc1, strDesc2, strDesc3 ))
					{
						if (Len(strDesc1)>0)
						{
							AddTooltipItemOption(0, strDesc1, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
							
						}
						if (Len(strDesc2)>0)
						{
							AddTooltipItemOption(0, strDesc2, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
						if (Len(strDesc3)>0)
						{
							AddTooltipItemOption(0, strDesc3, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
					}
				}
				
				//"��ȯ/��� �Ұ�"
				AddTooltipItemOption(1491, "", true, false, false);
				SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
				
				//�����
				if (Len(Item.Description)>0)
				{				
					AddTooltipItemBlank(12);
				}
			}
		break;
		
		// 2. ARMOR
		case ITEM_ARMOR:
			bLargeWidth = true;
			
			// Sheild
			if ( Item.SlotBitType == 256 && Item.ArmorType == 4 ) // ArmorType == 4 is sigil.. 
			{
				if (Len(SlotString)>0)
					AddTooltipItemOption(0, SlotString, false, true, false);
				if (Item.PhysicalDefense != 0)
					AddTooltipItemOption(95, String(GetPhysicalDefense(Item.CrystalType, Item.Enchanted, Item.PhysicalDefense)), true, true, false);	
				//Avoid Modify
				if (Item.AvoidModify != 0)
					AddTooltipItemOption(97, String(Item.AvoidModify), true, true, false);
					//Weight
				if (Item.Weight != 0)
					AddTooltipItemOption(52, String(Item.Weight), true, true, false);
			}
			else if (Item.SlotBitType == 256 || Item.SlotBitType == 128)	//SBT_LHAND or SBT_RHAND
			{
				if (Len(SlotString)>0)
					AddTooltipItemOption(0, SlotString, false, true, false);
				//Shield Defense
				//debug("Shield Defense" $ Item.ShieldDefense);
				if (Item.ShieldDefense != 0)
				AddTooltipItemOption(95, String(GetShieldDefense(Item.CrystalType, Item.Enchanted, Item.ShieldDefense)), true, true, false);
				
				//Shield Defense Rate
				//debug("Shield Defense Rate" $ Item.ShieldDefenseRate);
				if (Item.ShieldDefenseRate != 0)
				AddTooltipItemOption(317, String(Item.ShieldDefenseRate), true, true, false);
				
				//Avoid Modify
				//debug("Avoid Modify" $ Item.AvoidModify);
				if (Item.AvoidModify != 0)
				AddTooltipItemOption(97, String(Item.AvoidModify), true, true, false);
				
				//Weight
				//debug("Weight" $ Item.Weight);
				if (Item.Weight != 0)
				AddTooltipItemOption(52, String(Item.Weight), true, true, false);
			}
			
			// Magical Armor
			else if (IsMagicalArmor(Item.ID))
			{
				//Slot Type
				if (Len(SlotString)>0)
					AddTooltipItemOption(0, SlotString, false, true, false);
				
				//MP Bonus
				AddTooltipItemOption(388, String(Item.MpBonus), true, true, false);
				
				//Physical Defense
				if (Item.SlotBitType == 65536)
				{
					
				}
				else if (  Item.SlotBitType == 524288)
				{
				}
				else if ( Item.SlotBitType == 262144)
				{
				}
				else
				{
					if (Item.PhysicalDefense != 0)
					AddTooltipItemOption(95, String(GetPhysicalDefense(Item.CrystalType, Item.Enchanted, Item.PhysicalDefense)), true, true, false);
				}
					
				//Weight
					if (Item.Weight != 0)
					AddTooltipItemOption(52, String(Item.Weight), true, true, false);
			}
			
			// Physical Armor
			else
			{
				//Slot Type
				//debug("Physical Armor1 " $ Item.SlotBitType $ Item.PhysicalDefense);
				if (Len(SlotString)>0)
					AddTooltipItemOption(0, SlotString, false, true, false);
				
				//Physical Defense
				if (Item.SlotBitType == 65536)
				{
					
				}
				else if (  Item.SlotBitType == 524288)
				{
				}
				else if ( Item.SlotBitType == 262144)
				{
				}
				else
				{
					if (Item.PhysicalDefense != 0)
					AddTooltipItemOption(95, String(GetPhysicalDefense(Item.CrystalType, Item.Enchanted, Item.PhysicalDefense)), true, true, false);	
				}
				//Weight
				if (Item.Weight != 0)
				AddTooltipItemOption(52, String(Item.Weight), true, true, false);
			}
			//����ȿ��
			if (Item.RefineryOp1 != 0 || Item.RefineryOp2 != 0)
			{
				//�����
				AddTooltipItemBlank(12);
				
				//"[����ȿ��]"
				AddTooltipItemOption(1490, "", true, false, false);
				SetTooltipItemColor(255, 255, 255, 0);
				
				//�÷��� ���
				if (Item.RefineryOp2 != 0)
				{
					Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality( Item.RefineryOp2 );
					GetRefineryColor(Quality, ColorR, ColorG, ColorB);
				}
				
				if (Item.RefineryOp1 != 0)
				{
					strDesc1 = "";
					strDesc2 = "";
					strDesc3 = "";
					if (class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Item.RefineryOp1, strDesc1, strDesc2, strDesc3 ))
					{	
						if (Len(strDesc1)>0)
						{
							AddTooltipItemOption(0, strDesc1, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
						if (Len(strDesc2)>0)
						{
							AddTooltipItemOption(0, strDesc2, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
						if (Len(strDesc3)>0)
						{
							AddTooltipItemOption(0, strDesc3, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
					}
				}	
				
				if (Item.RefineryOp2 != 0)
				{
					strDesc1 = "";
					strDesc2 = "";
					strDesc3 = "";
					if (class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Item.RefineryOp2, strDesc1, strDesc2, strDesc3 ))
					{
						if (Len(strDesc1)>0)
						{
							AddTooltipItemOption(0, strDesc1, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
							
						}
						if (Len(strDesc2)>0)
						{
							AddTooltipItemOption(0, strDesc2, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
						if (Len(strDesc3)>0)
						{
							AddTooltipItemOption(0, strDesc3, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
					}
				}
				//�����
				AddTooltipItemBlank(12);
			}
			
		break;
		
		// 3. ACCESSARY
		case ITEM_ACCESSARY:
			bLargeWidth = true;
			
			//Slot Type
			if (Len(SlotString)>0)
				AddTooltipItemOption(0, SlotString, false, true, false);
			
			//Magical Defense
			// Ż�������� ������ ������ �������� �ʴ´�.
			// ������ ������� ������ �������� �ʴ´�. 
			if ((Item.SlotBitType != 4194304 ) && (Item.SlotBitType != 1048576 ) && (Item.SlotBitType != 2097152 ))
				AddTooltipItemOption(99, String(GetMagicalDefense(Item.CrystalType, Item.Enchanted, Item.MagicalDefense)), true, true, false);
			
			if (Item.Weight == 0)
				AddTooltipItemOption(52, " 0 ", true, true, false);
			else 
				AddTooltipItemOption(52, String(Item.Weight), true, true, false);
			
			//debug ("Refinery Result Accessotires" @ Item.RefineryOp1);
			//����ȿ��
			if (Item.RefineryOp1 != 0 || Item.RefineryOp2 != 0)
			{
				//�����
				AddTooltipItemBlank(12);
				
				//"[����ȿ��]"
				AddTooltipItemOption(1490, "", true, false, false);
				SetTooltipItemColor(255, 255, 255, 0);
				
				//�÷��� ���
				if (Item.RefineryOp2 != 0)
				{
					Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality( Item.RefineryOp2 );
					GetRefineryColor(Quality, ColorR, ColorG, ColorB);
				}
				
				if (Item.RefineryOp1 != 0)
				{
					strDesc1 = "";
					strDesc2 = "";
					strDesc3 = "";
					if (class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Item.RefineryOp1, strDesc1, strDesc2, strDesc3 ))
					{	
						if (Len(strDesc1)>0)
						{
							AddTooltipItemOption(0, strDesc1, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
						if (Len(strDesc2)>0)
						{
							AddTooltipItemOption(0, strDesc2, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
						if (Len(strDesc3)>0)
						{
							AddTooltipItemOption(0, strDesc3, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
					}
				}	
				
				if (Item.RefineryOp2 != 0)
				{
					strDesc1 = "";
					strDesc2 = "";
					strDesc3 = "";
					if (class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Item.RefineryOp2, strDesc1, strDesc2, strDesc3 ))
					{
						if (Len(strDesc1)>0)
						{
							AddTooltipItemOption(0, strDesc1, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
							
						}
						if (Len(strDesc2)>0)
						{
							AddTooltipItemOption(0, strDesc2, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
						if (Len(strDesc3)>0)
						{
							AddTooltipItemOption(0, strDesc3, false, true, false);
							SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						}
					}
				}
				//�����
				AddTooltipItemBlank(12);
			}
			
			
				
		break;
		
		// 4. QUEST
		case ITEM_QUESTITEM:
			bLargeWidth = true;
			
			//Slot Type
			if (Len(SlotString)>0)
				AddTooltipItemOption(0, SlotString, false, true, false);
		break;
		
		// 5. ETC
		case ITEM_ETCITEM:
			bLargeWidth = true;
			
			if (eEtcItemType == ITEME_PET_COLLAR)
			{
				//Pet Name
				if (Item.Damaged == 0)
					nTmp = 971;
				else
					nTmp = 970;
				AddTooltipItemOption2(969, nTmp, true, true, false);
				
				//Pet Level
				AddTooltipItemOption(88, String(Item.Enchanted), true, true, false);
			}
			else if (eEtcItemType == ITEME_TICKET_OF_LORD)
			{
				AddTooltipItemOption(972, String(Item.Enchanted), true, true, false);
			}
			else if (eEtcItemType == ITEME_LOTTO)
			{
				// ���ǿ����� bless�� ȸ��, ���ͷ��̽������� Enchant�� ȸ���Դϴ�. �����ϼ���! - lancelot 2008. 11. 11.
				// ȸ��
				AddTooltipItemOption(670, String(Item.Blessed), true, true, false);
				
				// ���ù�ȣ
				AddTooltipItemOption(671, GetLottoString(Item.Enchanted, Item.Damaged), true, true, false);
			}
			else if (eEtcItemType == ITEME_RACE_TICKET)
			{
				// ȸ��
				AddTooltipItemOption(670, String(Item.Enchanted), true, true, false);
				
				// ���ù�ȣ
				AddTooltipItemOption(671, GetRaceTicketString(Item.Blessed), true, true, false);
				
				//Money
				AddTooltipItemOption(744, String(Item.Damaged*100), true, true, false);
			}
			//Weight
			//~ if (Item.Price!=0)
			if (Item.Weight==0)
				AddTooltipItemOption(52, " 0 ", true, true, false);
			else
				AddTooltipItemOption(52, String(Item.Weight), true, true, false);
		break;
		
		}
		/////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////
		
		// [ĥ��ĥ��, �� ����] item enchant option - by jin 09/08/05
		if (Item.EnchantOption1 != 0 || Item.EnchantOption2 != 0 || Item.EnchantOption3 != 0)
		{
			//�����
			AddTooltipItemBlank(12);
			
			//"[��æƮȿ��]"
			AddTooltipItemOption(2214, "", true, false, false);
			SetTooltipItemColor(255, 255, 255, 0);
			
			//�÷��� ���
			if (Item.EnchantOption1 != 0)
			{
				// [ĥ��ĥ��, ������] ���� ȿ���� �ϴ� ������ 1�� ������ ���. - by jin 09/08/06
				GetRefineryColor(1, ColorR, ColorG, ColorB);
			}
			
			if (Item.EnchantOption1 != 0)
			{
				strDesc1 = "";
				strDesc2 = "";
				strDesc3 = "";
				if (class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Item.EnchantOption1, strDesc1, strDesc2, strDesc3 ))
				{	
					if (Len(strDesc1)>0)
					{
						AddTooltipItemOption(0, strDesc1, false, true, false);
						SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
					}
					if (Len(strDesc2)>0)
					{
						AddTooltipItemOption(0, strDesc2, false, true, false);
						SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
					}
					if (Len(strDesc3)>0)
					{
						AddTooltipItemOption(0, strDesc3, false, true, false);
						SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
					}
				}
			}	
			
			if (Item.EnchantOption2 != 0)
			{
				strDesc1 = "";
				strDesc2 = "";
				strDesc3 = "";
				if (class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Item.EnchantOption2, strDesc1, strDesc2, strDesc3 ))
				{
					if (Len(strDesc1)>0)
					{
						AddTooltipItemOption(0, strDesc1, false, true, false);
						SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						
					}
					if (Len(strDesc2)>0)
					{
						AddTooltipItemOption(0, strDesc2, false, true, false);
						SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
					}
					if (Len(strDesc3)>0)
					{
						AddTooltipItemOption(0, strDesc3, false, true, false);
						SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
					}
				}
			}

			if (Item.EnchantOption3 != 0)
			{
				strDesc1 = "";
				strDesc2 = "";
				strDesc3 = "";
				if (class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Item.EnchantOption3, strDesc1, strDesc2, strDesc3 ))
				{
					if (Len(strDesc1)>0)
					{
						AddTooltipItemOption(0, strDesc1, false, true, false);
						SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
						
					}
					if (Len(strDesc2)>0)
					{
						AddTooltipItemOption(0, strDesc2, false, true, false);
						SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
					}
					if (Len(strDesc3)>0)
					{
						AddTooltipItemOption(0, strDesc3, false, true, false);
						SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
					}
				}
			}

			//�����
			AddTooltipItemBlank(12);
		}
		
		//������ ������
		if (Item.CurrentDurability >= 0 && Item.Durability > 0)
		{
			bLargeWidth = true;
			
			//�����
			AddTooltipItemBlank(12);
			
			//<���� ���� ����>
			AddTooltipItemOption(1492, "", true, false, false);
			SetTooltipItemColor(255, 255, 255, 0);
			
			//��밡�� �ð�
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_ID = 1493;
			EndItem();
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = true;
			if (Item.CurrentDurability+1 <= 5)
			{
				m_Info.t_color.R = 255;
				m_Info.t_color.G = 0;
				m_Info.t_color.B = 0;
			}
			else
			{
				m_Info.t_color.R = 176;
				m_Info.t_color.G = 155;
				m_Info.t_color.B = 121;
			}
			m_Info.t_color.A = 255;
			m_Info.t_strText = " " $ Item.CurrentDurability $ "/" $ Item.Durability;
			EndItem();
			
			//"��ȯ/��� �Ұ�"
			AddTooltipItemOption(1491, "", true, false, false);
			
			//�����
			if (Len(Item.Description)>0)
			{
				AddTooltipItemBlank(12);
			}
		}
		
		//branch
		//������ ����
		if (Item.BR_MaxEnergy > 0)
		{
			//bLargeWidth = true;
			
			//�����
			AddTooltipItemBlank(12);
			//<������ ����>
			AddTooltipItemOption(5065, "", true, false, false);
			SetTooltipItemColor(255, 255, 255, 0);

			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_ID = 5066;
			EndItem();
						
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.t_bDrawOneLine = true;
			m_Info.bLineBreak = true;
			if ( Item.BR_CurrentEnergy==0 || (Item.BR_MaxEnergy / Item.BR_CurrentEnergy > 10) )
			{
				m_Info.t_color.R = 255;
				m_Info.t_color.G = 0;
				m_Info.t_color.B = 0;
			}
			else
			{
				m_Info.t_color.R = 176;
				m_Info.t_color.G = 155;
				m_Info.t_color.B = 121;
			}
			m_Info.t_color.A = 255;
			//m_Info.t_strText = "  " $ Item.BR_CurrentEnergy $ "/" $ Item.BR_MaxEnergy;
			m_Info.t_strText = " " ;
			ParamAdd(m_Info.Condition, "Type", "CurrentEnergy");
			EndItem();
		}
		//end of branch
		
		//����
		if (Len(Item.Description)>0)
		{
			bLargeWidth = true;
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Item.Description;
			EndItem();
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////
		// ��Ʈ ������ ����
		if (IsValidItemID(Item.ID))
		{
			for (idx=0; idx<TOOLTIP_SETITEM_MAX; idx++)
			{
				//��Ʈ������ ����Ʈ
				
				for (SetID=0; SetID<class'UIDATA_ITEM'.static.GetSetItemNum(Item.ID, idx); SetID++) //0,1,2�� ��Ʈ������ȿ�� �� ���ؼ� ���� ����� ��Ʈ�� �Ϻ�Ǿ��ϳ�..
				{ 					
					bLargeWidth = true;
					if (!class'UIDATA_ITEM'.static.IsExistSetItem(Item.ID, idx, SetID))
					{					
						tmpItemID.classID = class'UIDATA_ITEM'.static.GetSetItemFirstID(Item.ID, idx, SetID);
				
						if (tmpItemID.classID > 0)
						{
							strTmp = class'UIDATA_ITEM'.static.GetItemName(tmpItemID);
							StartItem();
							m_Info.eType = DIT_TEXT;
							m_Info.nOffSetY = 6;
							m_Info.bLineBreak = true;
							m_Info.t_bDrawOneLine = true;
							m_Info.t_color.R = 112;
							m_Info.t_color.G = 115;
							m_Info.t_color.B = 123;
							m_Info.t_color.A = 255;
							m_Info.t_strText = strTmp;
							ParamAdd(m_info.Condition, "SetItemNum", string(idx));
							ParamAdd(m_Info.Condition, "Type", "Equip");
							ParamAddItemID(m_Info.Condition, Item.ID);						
							ParamAdd(m_Info.Condition, "CurTypeID", string(SetID));		//���� �������� Type ��(0��:�䰩 1��:���� 2��:��� 3��:�� 4�� �ٸ� ..ItemName.txt�� ����ִ¼���
							ParamAdd(m_Info.Condition, "NormalColor", "112,115,123");
							ParamAdd(m_Info.Condition, "EnableColor", "176,185,205");
							EndItem();
						}
					}
				}			
		
				//��Ʈȿ��
				strTmp = class'UIDATA_ITEM'.static.GetSetItemEffectDescription(Item.ID, idx);
				if (Len(strTmp)>0)
				{
					bLargeWidth = true;
					
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.nOffSetY = 6;
					m_Info.bLineBreak = true;
					m_Info.t_color.R = 128;
					m_Info.t_color.G = 127;
					m_Info.t_color.B = 103;
					m_Info.t_color.A = 255;
					m_Info.t_strText = strTmp;
					ParamAdd(m_Info.Condition, "Type", "SetEffect");
					ParamAddItemID(m_Info.Condition, Item.ID);
					ParamAdd(m_Info.Condition, "EffectID", String(idx));
					ParamAdd(m_Info.Condition, "NormalColor", "128,127,103");
					ParamAdd(m_Info.Condition, "EnableColor", "183,178,122");
					EndItem();	
				}
			}
			//��þƮ ��Ʈȿ��
			strTmp = class'UIDATA_ITEM'.static.GetSetItemEnchantEffectDescription(Item.ID);
			if (Len(strTmp)>0)
			{
				bLargeWidth = true;
				
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = 6;
				m_Info.bLineBreak = true;
				m_Info.t_color.R = 74;
				m_Info.t_color.G = 92;
				m_Info.t_color.B = 104;
				m_Info.t_color.A = 255;
				m_Info.t_strText = strTmp;
				ParamAdd(m_Info.Condition, "Type", "EnchantEffect");
				ParamAddItemID(m_Info.Condition, Item.ID);
				ParamAdd(m_Info.Condition, "NormalColor", "74,92,104");
				ParamAdd(m_Info.Condition, "EnableColor", "111,146,169");
				EndItem();
			}
		}
		
		//����Ʈ ������ ǥ���Ѵ�.
		AddTooltipItemQuestList(Item);
		
		// �Ӽ� �������� �׷��ش�. 
		AddTooltipItemAttributeGage(Item);
		
		// �Ⱓ�� ������
		if ( Item.CurrentPeriod > 0)
		{
			//�����
			AddTooltipItemBlank(12);
			
			//<�Ⱓ�� ������>
			AddTooltipItemOption(1739, "", true, false, false);
			SetTooltipItemColor(255, 255, 255, 0);
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_ID = 1199;
			EndItem();
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " : ";
			EndItem();
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = "" $ MakeTimeStr(Item.CurrentPeriod);
			ParamAdd(m_Info.Condition, "Type", "PeriodTime");
			EndItem();
		}
	}
	else
	{
		return;
	}
	
	if (bLargeWidth)
		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;

	if(TooltipType == "InventoryPawnViewer")				// PawnViewer�� �߰� - lancelot 2007. 10. 16.
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.nOffSetY = 6;
		m_Info.t_bDrawOneLine = true;
		m_Info.bLineBreak = true;
		m_Info.t_strText ="ID : "$string(Item.Id.classID);
		EndItem();
	}

	ReturnTooltipInfo(m_Tooltip);
}


/////////////////////////////////////////////////////////////////////////////////
// ACTION
function ReturnTooltip_NTT_ACTION(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo Item;
	
	if (eSourceType == NTST_ITEM)
	{
		ParseString( param, "Name", Item.Name);
		ParseString( param, "Description", Item.Description);
		
		//�׼� �̸�
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strText = Item.Name;
		EndItem();
		
		//�׼� ����
		if (Len(Item.Description)>0)
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = false;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Item.Description;
			EndItem();
		}		
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// SKILL
function ReturnTooltip_NTT_SKILL(string param, ETooltipSourceType eSourceType)
{
	
	local ItemInfo Item;
	
	local EItemParamType eItemParamType;
	local EShortCutItemType eShortCutType;
	local int nTmp;
	local int SkillLevel;
	
	debug("����������");
	if (eSourceType == NTST_ITEM)
	{
		ParseItemID( param, Item.ID );
		ParseString( param, "Name", Item.Name);
		ParseString( param, "AdditionalName", Item.AdditionalName);
		ParseString( param, "Description", Item.Description);
		ParseInt( param, "Level", Item.Level);
		
		eShortCutType = EShortCutItemType(Item.ItemSubType);
		eItemParamType = EItemParamType(Item.ItemType);
		SkillLevel = Item.Level;
		
		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
		
		//������ �̸�
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strText = Item.Name;
		EndItem();
		
		// ��æƮ�� ��ȯ�� ������ ���� ������ ��ȯ�����ش�. 
		if (Len(Item.AdditionalName)>0)
		{			
			SkillLevel = class'UIDATA_SKILL'.static.GetEnchantSkillLevel( Item.ID, Item.Level );
		}
		
		//ex) " Lv "
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strText = " ";
		EndItem();
		
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_ID = 88;
		EndItem();
		
		//��ų ����
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		m_Info.t_strText = " " $ SkillLevel;
		EndItem();
		
		// ��æƮ ������ �ѷ��ִ� ���� �̰�
		if (Len(Item.AdditionalName)>0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetX = 5;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 217;
			m_Info.t_color.B = 105;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Item.AdditionalName;
			EndItem();
		}
		
		//Operate Type
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.nOffSetY = 6;
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		m_Info.t_strText = class'UIDATA_SKILL'.static.GetOperateType( Item.ID, Item.Level );
		EndItem();
		
		//�Ҹ�HP
		nTmp = class'UIDATA_SKILL'.static.GetHpConsume( Item.ID, Item.Level );
		if (nTmp>0)
		{
			AddTooltipItemOption(1195, String(nTmp), true, true, false);
		}
		
		//�Ҹ�MP
		nTmp = class'UIDATA_SKILL'.static.GetMpConsume( Item.ID, Item.Level );
		if (nTmp>0)
		{
			AddTooltipItemOption(320, String(nTmp), true, true, false);
		}
		
		//��ȿ�Ÿ�
		nTmp = class'UIDATA_SKILL'.static.GetCastRange( Item.ID, Item.Level );
		if (nTmp>=0)
		{
			AddTooltipItemOption(321, String(nTmp), true, true, false);
		}
		
		//����
		if (Len(Item.Description)>0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Item.Description;
			EndItem();	
		}		
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// ABNORMALSTATUS
function ReturnTooltip_NTT_ABNORMALSTATUS(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo Item;
	local int ShowLevel;
	
	local EItemParamType eItemParamType;
	local EShortCutItemType eShortCutType;
	
	if (eSourceType == NTST_ITEM)
	{
		ParseItemID( param, Item.ID );
		ParseString( param, "Name", Item.Name);
		ParseString( param, "AdditionalName", Item.AdditionalName);
		ParseString( param, "Description", Item.Description);
		ParseInt( param, "Level", Item.Level);
		ParseInt( param, "Reserved", Item.Reserved);
		
		eShortCutType = EShortCutItemType(Item.ItemSubType);
		eItemParamType = EItemParamType(Item.ItemType);
		
		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
		
		//������ �̸�
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strText = Item.Name;
		EndItem();
		
		ShowLevel = Item.Level;
		if (Len(Item.AdditionalName)>0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetX = 5;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 217;
			m_Info.t_color.B = 105;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Item.AdditionalName;
			EndItem();
			
			ShowLevel = class'UIDATA_SKILL'.static.GetEnchantSkillLevel( Item.ID, Item.Level );
		}
		
		//ex) " Lv "
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strText = " ";
		EndItem();
		
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_ID = 88;
		EndItem();
		
		//��ų ����
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		m_Info.t_strText = " " $ ShowLevel;
		EndItem();
		
		//�����ð�
		if (!IsDeBuff(Item.ID, Item.Level) && Item.Reserved>=0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_ID = 1199;
			EndItem();
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " : ";
			EndItem();
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 176;
			m_Info.t_color.G = 155;
			m_Info.t_color.B = 121;
			m_Info.t_color.A = 255;
			m_Info.t_strText = MakeBuffTimeStr(Item.Reserved);
			ParamAdd(m_Info.Condition, "Type", "RemainTime");
			EndItem();
		}
		
		//����
		if (Len(Item.Description)>0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Item.Description;
			EndItem();	
		}		
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// NORMALITEM
function ReturnTooltip_NTT_NORMALITEM(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo Item;
	
	if (eSourceType == NTST_ITEM)
	{
		ParseString( param, "Name", Item.Name);
		ParseString( param, "Description", Item.Description);
		ParseString( param, "AdditionalName", Item.AdditionalName);
		ParseInt( param, "CrystalType", Item.CrystalType);
		
		//������ �̸�
		AddTooltipItemName(Item.Name, Item, 1);
		
		//Grade Mark
		AddTooltipItemGrade(Item);
		
		//����
		if (Len(Item.Description)>0)
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Item.Description;
			EndItem();	
		}		
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// RECIPE
function ReturnTooltip_NTT_RECIPE(string param, ETooltipSourceType eSourceType, bool bShowPrice)
{
	local ItemInfo Item;
	
	local string strAdena;
	local string strAdenaComma;
	local color	 AdenaColor;
	
	if (eSourceType == NTST_ITEM)
	{
		ParseString( param, "Name", Item.Name);
		ParseString( param, "Description", Item.Description);
		ParseString( param, "AdditionalName", Item.AdditionalName);
		ParseInt( param, "CrystalType", Item.CrystalType);
		ParseInt( param, "Weight", Item.Weight);
		ParseINT64( param, "Price", Item.Price);
		
		//������ �̸�
		AddTooltipItemName(Item.Name, Item, 1);
		
		//Grade Mark
		AddTooltipItemGrade(Item);
		
		//����
		if (bShowPrice)
		{
			strAdena = Int64ToString(Item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			
			//���� : xxx,xxx,xxx
			AddTooltipItemOption(641, strAdenaComma $ " ", true, true, false);
			SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
			
			//"�Ƶ���"
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color = AdenaColor;
			m_Info.t_ID= 469;
			EndItem();
			
			//�о��ֱ� ��Ʈ��
			AddTooltipItemOption(0, "(" $ ConvertNumToText(strAdena) $ ")", false, true, false);
			SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
		}
		
		//Weight
		AddTooltipItemOption(52, String(Item.Weight), true, true, false);
		
		//����
		if (Len(Item.Description)>0)
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Item.Description;
			EndItem();	
		}		
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// SHORTCUT
function ReturnTooltip_NTT_SHORTCUT(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo Item;
	
	local EItemParamType eItemParamType;
	local EShortCutItemType eShortCutType;
	local string ItemName;
	local ShortcutCommandItem commandItem;
	local int shortcutID;
	local string strShort;
	local ItemID MacroID;
	local MacroInfo mInfo;
	local int idx;

	local ShortcutAssignWnd Script;

	Script = ShortcutAssignWnd( GetScript( "OptionWnd.ShortcutTab" ) );

	strShort = "<" $ GetSystemString(1523) $ ": ";
	
	if (eSourceType == NTST_ITEM)
	{   
		if( BoolSelect )
		{
			ParseInt( param, "ItemSubType", Item.ItemSubType);
			ParseString( param, "Name", Item.Name);
			ParseInt( param, "RefineryOp1", Item.RefineryOp1);
			ParseInt( param, "RefineryOp2", Item.RefineryOp2);
			eShortCutType = EShortCutItemType(Item.ItemSubType);
			//������ �̸� ���
			ItemName = class'UIDATA_ITEM'.static.GetRefineryItemName( Item.Name, Item.RefineryOp1, Item.RefineryOp2 );
			switch (eShortCutType)
			{
			case SCIT_ITEM:
				ReturnTooltip_NTT_ITEM(param, "inventory", eSourceType);
				break;
			case SCIT_SKILL:			
				ReturnTooltip_NTT_SKILL(param, eSourceType);
				break;
			case SCIT_ACTION:
			case SCIT_MACRO:
				if (eSourceType == NTST_ITEM)
				{
					ParseString( param, "Name", Item.Name);
					ParseString( param, "Description", Item.Description);
					ParseInt( param, "ClassID", MacroID.ClassID);
					
					class'UIDATA_MACRO'.static.GetMacroInfo( MacroID, mInfo );
					
					m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;

					//�׼� �̸�
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = Item.Name;
					EndItem();
					
					//�׼� ����
					if (Len(Item.Description)>0)
					{						
						StartItem();
						m_Info.eType = DIT_TEXT;
						m_Info.nOffSetY = 6;
						m_Info.t_bDrawOneLine = false;
						m_Info.bLineBreak = true;
						m_Info.t_color.R = 178;
						m_Info.t_color.G = 190;
						m_Info.t_color.B = 207;
						m_Info.t_color.A = 255;
						m_Info.t_strText = Item.Description;
						EndItem();
					}

					for ( idx = 0; idx < 12; idx++ )
					{
						if ( mInfo.CommandList[idx] != "" )
						{
							StartItem();
							m_Info.eType = DIT_TEXT;
							m_Info.nOffSetY = 6;
							m_Info.t_bDrawOneLine = false;
							m_Info.bLineBreak = true;
							m_Info.t_color.R = 123;
							m_Info.t_color.G = 63;
							m_Info.t_color.B = 178;
							m_Info.t_color.A = 255;
							m_Info.t_strText = mInfo.CommandList[idx];
							EndItem();
						}
					}
					
				}
				else
				{
					return;
				}
					
				ReturnTooltipInfo(m_Tooltip);
				break;
			case SCIT_RECIPE:
			case SCIT_BOOKMARK:
				//������ �̸�
				m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
				StartItem();
				m_Info.eType = DIT_TEXT;
				//m_Info.bLineBreak = true;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_strText = ItemName;
				EndItem();
				break;
			default:
				break;
			}
			ParseINT(param, "ShortcutID", shortcutID);
			if( GetOptionBool( "Game", "EnterChatting" ) )
			{
				class'ShortcutAPI'.static.GetAssignedKeyFromCommand("TempStateShortcut", "UseShortcutItem Num=" $ shortcutID, commandItem);
			}
			else
			{
				class'ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", "UseShortcutItem Num=" $ shortcutID, commandItem);
			}
			
			
			//����Ű ����...
			if( commandItem.subkey1 != "" )
			{
				strShort = strShort $ Script.GetUserReadableKeyName( commandItem.subkey1 ) $ "+";
			}
			if( commandItem.subkey2 != "" )
			{
				strShort = strShort $ Script.GetUserReadableKeyName( commandItem.subkey2 ) $ "+";
			}
			if( commandItem.Key != "" )
			{
				strShort = strShort $ Script.GetUserReadableKeyName( commandItem.Key ) $ ">";
			}

			if( commandItem.subkey1 == "" && commandItem.subkey2 == "" && commandItem.Key == "" )
			{
				strShort = strShort $ GetSystemString(27) $">";
			}
			
			//���߰�~
			AddTooltipItemBlank(6);		

			StartItem();
			m_Info.eType = DIT_SPLITLINE;
			m_Info.u_nTextureWidth = TOOLTIP_MINIMUM_WIDTH;			
			m_Info.u_nTextureHeight = 1;
			m_Info.u_strTexture ="L2ui_ch3.tooltip_line";
			EndItem();

			if( ItemName != "" )
			{
				AddTooltipItemBlank(5);
				
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_strText = strShort;
				EndItem();
				
				AddTooltipItemBlank(1);
				
				ReturnTooltipInfo(m_Tooltip);				
			}
			return;
		}
		else
		{
			ParseItemID( param, Item.ID );
			ParseString( param, "Name", Item.Name);
			ParseString( param, "AdditionalName", Item.AdditionalName);
			ParseInt( param, "Level", Item.Level);
			ParseInt( param, "Reserved", Item.Reserved);
			ParseInt( param, "Enchanted", Item.Enchanted);
			ParseInt( param, "ItemType", Item.ItemType);
			ParseInt( param, "ItemSubType", Item.ItemSubType);
			ParseInt( param, "CrystalType", Item.CrystalType);
			ParseInt( param, "ConsumeType", Item.ConsumeType);
			ParseInt( param, "RefineryOp1", Item.RefineryOp1);
			ParseInt( param, "RefineryOp2", Item.RefineryOp2);
			ParseINT64( param, "ItemNum", Item.ItemNum);
			ParseInt( param, "MpConsume", Item.MpConsume);
			//branch
			ParseInt ( param, "IsBRPremium", Item.IsBRPremium);
			//end of branch

			eShortCutType = EShortCutItemType(Item.ItemSubType);
			eItemParamType = EItemParamType(Item.ItemType);

			//������ �̸� ���
			ItemName = class'UIDATA_ITEM'.static.GetRefineryItemName( Item.Name, Item.RefineryOp1, Item.RefineryOp2 );

			switch (eShortCutType)
			{
			case SCIT_ITEM:
				//branch
				AddPrimeItemSymbol(Item);
				//end of branch
				//��þƮ ex) "+10"
				AddTooltipItemEnchant(Item);

				//������ �̸�
				AddTooltipItemName(ItemName, Item, 1);

				//Grade Mark
				AddTooltipItemGrade(Item);

				//������ ����
				AddTooltipItemCount(Item);
				break;
			case SCIT_SKILL:			
				//������ �̸�
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_strText = ItemName;
				EndItem();

				if (Len(Item.AdditionalName)>0)
				{
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.nOffSetX = 5;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_color.R = 255;
					m_Info.t_color.G = 217;
					m_Info.t_color.B = 105;
					m_Info.t_color.A = 255;
					m_Info.t_strText = Item.AdditionalName;
					EndItem();

					Item.Level = class'UIDATA_SKILL'.static.GetEnchantSkillLevel( Item.ID, Item.Level );
				}

				//ex) " Lv "
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_strText = " ";
				EndItem();

				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color.R = 163;
				m_Info.t_color.G = 163;
				m_Info.t_color.B = 163;
				m_Info.t_color.A = 255;
				m_Info.t_ID = 88;
				EndItem();

				//��ų ����
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color.R = 176;
				m_Info.t_color.G = 155;
				m_Info.t_color.B = 121;
				m_Info.t_color.A = 255;
				m_Info.t_strText = " " $ Item.Level;
				EndItem();

				//MP�Ҹ�
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_strText = " (";
				EndItem();

				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_ID = 91;
				EndItem();

				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_strText = ":" $ Item.MpConsume $ ")";
				EndItem();
				break;

			case SCIT_ACTION:
			case SCIT_MACRO:
			case SCIT_RECIPE:
			case SCIT_BOOKMARK:
				//������ �̸�
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_strText = ItemName;
				EndItem();
				break;
			}
		}
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// RECIPE_MANUFACTURE
function ReturnTooltip_NTT_RECIPE_MANUFACTURE(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo Item;
	
	if (eSourceType == NTST_ITEM)
	{
		ParseString( param, "Name", Item.Name);
		ParseString( param, "Description", Item.Description);
		ParseString( param, "AdditionalName", Item.AdditionalName);
		ParseINT64( param, "Reserved64", Item.Reserved64);
		ParseInt( param, "CrystalType", Item.CrystalType);
		ParseINT64( param, "ItemNum", Item.ItemNum);
		
		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
		
		//������ �̸�
		AddTooltipItemName(Item.Name, Item, 1);
		
		//Grade Mark
		AddTooltipItemGrade(Item);
		
		//ex) "�ʿ�� : 2"
		AddTooltipItemOption(736, Int64ToString(Item.Reserved64), true, true, false);
		
		//ex) "������ : 0"
		AddTooltipItemOption(737, Int64ToString(Item.ItemNum), true, true, false);
		
		//����
		if (Len(Item.Description)>0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Item.Description;
			EndItem();	
		}
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// PLEDGEINFO
function ReturnTooltip_NTT_CLANINFO(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		//ex) "���� : ���������"
		AddTooltipItemOption(391, GetClassType(int(record.LVDataList[2].szData)), true, true, true);
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

//by Merc
function ReturnTooltip_NTT_RADARINFO(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		//ex) "���� : ���������"
		AddTooltipItemOption(391, GetClassType(int(record.LVDataList[3].szData)), true, true, true);
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

//���� ����(2010.03.30) �Ϸ�
function ReturnTooltip_NTT_POSTINFO(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );

		//ex) "���� : ���������"
		AddTooltipItemOption(391, GetClassType(int(record.LVDataList[1].szData)), true, true, true);
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}


//���� ����(2010.02.22 ~ 03.08) �Ϸ�
/////////////////////////////////////////////////////////////////////////////////
// ROOMLIST
function ReturnTooltip_NTT_ROOMLIST(string param, ETooltipSourceType eSourceType)
{
	local int i;
	local LVDataRecord record;
	local int len;
	
	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH + 40;

	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		len = int( record.LVDataList[6].szData );

		for( i = 0 ; i < len ; i++ )
		{
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.u_nTextureWidth = 11;
			m_Info.u_nTextureHeight = 11;
			m_Info.u_strTexture = GetClassIconName( record.LVDataList[7 + i].nReserved1 );
			EndItem();

			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.t_bDrawOneLine = false;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " " $ record.LVDataList[7 + i].szData;
			EndItem();
			if( i != len - 1 )
			{
				AddTooltipItemBlank(2);
			}
		}

		//ex) "���� : ���������"
		//AddTooltipItemOption(391, GetClassType(int(record.LVDataList[2].szData)), true, true, true);
	}
	else
	{
		return;
	}

	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// USERLIST
function ReturnTooltip_NTT_USERLIST(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH + 80;

	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		//ex) "���� : ���������"
		AddTooltipItemOption(391, GetClassType(int(record.LVDataList[1].szData)), true, true, true);
		
		AddTooltipItemBlank(0);
		//ex)�ͼ� ���� : 
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_strText = GetSystemString( 2276 ) $ " : ";
		EndItem();
		
		//����
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		if( record.LVDataList[5].szData == "" )
		{			
			m_Info.t_strText = GetSystemString( 27 );
		}
		else
		{			
			m_Info.t_strText = record.LVDataList[5].szData;
		}
		EndItem();
		
		
	}
	else
	{
		return;
	}
	
	
	ReturnTooltipInfo(m_Tooltip);
}


/////////////////////////////////////////////////////////////////////////////////
// PARTYMATCH
function ReturnTooltip_NTT_PARTYMATCH(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH + 80;

	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		//ex) "���� : ���������"
		AddTooltipItemOption(391, GetClassType(int(record.LVDataList[1].szData)), true, true, true);
		
		//���� ����(2010.02.22 ~ 03.08) �Ϸ�
		//ex)���� ��ġ : �۷���
		AddTooltipItemOption(471, GetZoneNameWithZoneID(int(record.LVDataList[3].szReserved)), true, true, true);
		
		/*
		AddTooltipItemBlank(0);
		//�ͼ�����
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = false;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_strText = GetSystemString( 2276 ) @ ":";
		EndItem();		
		
		//����
		
		StartItem();
		m_Info.eType = DIT_TEXT;		
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		if( record.LVDataList[4].szData == "" )
		{
			//m_Info.bLineBreak = true;
			m_Info.t_strText = "" @ GetSystemString( 27 );
		}
		else
		{
			m_Info.bLineBreak = true;
			m_Info.t_strText = record.LVDataList[4].szData;
		}
		EndItem();
		*/

		
		AddTooltipItemBlank(0);
		//ex)�ͼ� ���� : 
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_strText = GetSystemString( 2276 ) $ " : ";
		//m_Info.t_strText = "�ͼ� ���� : ";
		EndItem();
		
		//����
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		if( record.LVDataList[4].szReserved == "" )
		{			
			m_Info.t_strText = GetSystemString( 27 );
		}
		else
		{			
			m_Info.t_strText = record.LVDataList[4].szReserved;
		}
		EndItem();
		
		
	}
	else
	{
		return;
	}
	
	
	ReturnTooltipInfo(m_Tooltip);
}

//���� �߰� UNION ���� ������ ������ ���.
/////////////////////////////////////////////////////////////////////////////////
// UINONLIST
function ReturnTooltip_NTT_UNIONLIST(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		//ex) "���� : ���������"
		AddTooltipItemOption(391, GetClassType(int(record.LVDataList[1].szData)), true, true, true);
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// QUESTLIST
function ReturnTooltip_NTT_QUESTLIST(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	local int nTmp;
	
	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		//����Ʈ �̸�
		AddTooltipItemOption(1200, record.LVDataList[0].szData, true, true, true);
		
		//�ݺ���
		switch(record.LVDataList[3].nReserved1)
		{
		case 0:
		case 2:
			nTmp = 861;
			break;
		case 1:
		case 3:
			nTmp = 862;
			break;
		}
		AddTooltipItemOption2(1202, nTmp, true, true, false);
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// RAIDLIST
function ReturnTooltip_NTT_RAIDLIST(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		if (Len(record.szReserved)<1)
			return;
		
		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
		
		//���̵� ����
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = false;
		m_Info.t_color.R = 178;
		m_Info.t_color.G = 190;
		m_Info.t_color.B = 207;
		m_Info.t_color.A = 255;
		m_Info.t_strText = record.szReserved;
		EndItem();
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// QUESTINFO
function ReturnTooltip_NTT_QUESTINFO(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	local int nTmp;
	local int Width1;
	local int Width2;
	local int Height;
		
	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		//����Ʈ �̸�
		AddTooltipItemOption(1200, record.LVDataList[0].szData, true, true, true);
		
		//��������
		AddTooltipItemOption(1201, record.LVDataList[1].szData, true, true, false);
		
		//Width����!
		GetTextSizeDefault(GetSystemString(1200) $ " : " $ record.LVDataList[0].szData, Width1, Height);
		GetTextSizeDefault(GetSystemString(1201) $ " : " $ record.LVDataList[1].szData, Width2, Height);
		if (Width2>Width1)
			Width1 = Width2;
		if (TOOLTIP_MINIMUM_WIDTH>Width1)
			Width1 = TOOLTIP_MINIMUM_WIDTH;
		m_Tooltip.MinimumWidth = Width1 + 30;
		
		//��õ����
		AddTooltipItemOption(922, record.LVDataList[2].szData, true, true, false);
		
		//�ݺ���
		switch(record.LVDataList[3].nReserved1)
		{
		case 0:
		case 2:
			nTmp = 861;
			break;
		case 1:
		case 3:
			nTmp = 862;
			break;
		}
		AddTooltipItemOption2(1202, nTmp, true, true, false);
		
		//����Ʈ����
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.nOffSetY = 6;
		m_Info.t_bDrawOneLine = false;
		m_Info.bLineBreak = true;
		m_Info.t_color.R = 178;
		m_Info.t_color.G = 190;
		m_Info.t_color.B = 207;
		m_Info.t_color.A = 255;
		m_Info.t_strText = record.szReserved;
		EndItem();
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// MANOR
function ReturnTooltip_NTT_MANOR(string param, string TooltipType, ETooltipSourceType eSourceType)
{
	local LVDataRecord record;
	
	local int idx1;
	local int idx2;
	local int idx3;
	
	if (eSourceType == NTST_LIST)
	{
		ParamToRecord( param, record );
		
		if (TooltipType == "ManorSeedInfo")
		{
			idx1 = 4;
			idx2 = 5;
			idx3 = 6;
		}
		else if (TooltipType == "ManorCropInfo")
		{
			idx1 = 5;
			idx2 = 6;
			idx3 = 7;
		}
		else if (TooltipType == "ManorSeedSetting")
		{
			idx1 = 7;
			idx2 = 8;
			idx3 = 9;
		}
		else if (TooltipType == "ManorCropSetting")
		{
			idx1 = 9;
			idx2 = 10;
			idx3 = 11;
		}
		else if (TooltipType == "ManorDefaultInfo")
		{
			idx1 = 1;
			idx2 = 4;
			idx3 = 5;
		}
		else if (TooltipType == "ManorCropSell")
		{
			idx1 = 7;
			idx2 = 8;
			idx3 = 9;
		}
		
		// ���� or �۹� �̸�
		AddTooltipItemOption(0, record.LVDataList[0].szData, false, true, true);
		
		// ����
		AddTooltipItemOption(537, record.LVDataList[idx1].szData, true, true, false);

		// ���� Ÿ��1
		AddTooltipItemOption(1134, record.LVDataList[idx2].szData, true, true, false);
		
		// ���� Ÿ��2
		AddTooltipItemOption(1135, record.LVDataList[idx3].szData, true, true, false);
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

// [����Ʈ ������ ���� �߰�]
function ReturnTooltip_NTT_QUESTREWARDS(string param, ETooltipSourceType eSourceType)
{
	// [����Ʈ ������ ���� �߰�] �� �κп� ����Ʈ ������ ������ �ɸ´� �ڵ尡 ���� �� �� �����ϴ�.
	// 2009.10.14
	// ReturnTooltip_NTT_ITEM(param, "Inventoty", eSourceType);
	ReturnTooltip_NTT_ITEM(param, "QuestReward", eSourceType);
}

//"XXX : YYYY" ������ TooltipItem�� ���ϰ� �߰��� �ش�.
function AddTooltipItemOption(int TitleID, string Content, bool bTitle, bool bContent, bool IamFirst)
{
	if (bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		if (!IamFirst)
			m_Info.nOffSetY = 6;
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_ID = TitleID;
		EndItem();
	}
	
	if (Content != "0")
	{
		if (bContent)
		{
			if (bTitle)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				if (!IamFirst)
					m_Info.nOffSetY = 6;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color.R = 163;
				m_Info.t_color.G = 163;
				m_Info.t_color.B = 163;
				m_Info.t_color.A = 255;
				m_Info.t_strText = " : ";
				EndItem();
			}
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			if (!IamFirst)
				m_Info.nOffSetY = 6;
			if (!bTitle)
				m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 176;
			m_Info.t_color.G = 155;
			m_Info.t_color.B = 121;
			m_Info.t_color.A = 255;
			m_Info.t_strText = Content;
			EndItem();
		}
	}
}

//"XXX : YYYY" ������ TooltipItem�� ���ϰ� �߰��� �ش�.
//SYSSTRING : SYSSTRING
function AddTooltipItemOption2(int TitleID, int ContentID, bool bTitle, bool bContent, bool IamFirst)
{
	if (bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		if (!IamFirst)
			m_Info.nOffSetY = 6;
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_ID = TitleID;
		EndItem();
	}
	
	if (bContent)
	{	
		if (bTitle)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			if (!IamFirst)
				m_Info.nOffSetY = 6;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " : ";
			EndItem();
		}		
		
		StartItem();
		m_Info.eType = DIT_TEXT;
		if (!IamFirst)
			m_Info.nOffSetY = 6;
		if (!bTitle)
			m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		m_Info.t_ID = ContentID;
		EndItem();
	}
}

//�������� ������ �ٽ� �������ش�.
function SetTooltipItemColor(int R, int G, int B, int Offset)
{
	local int idx;
	idx = m_Tooltip.DrawList.Length-1-Offset;
	m_Tooltip.DrawList[idx].t_color.R = R;
	m_Tooltip.DrawList[idx].t_color.G = G;
	m_Tooltip.DrawList[idx].t_color.B = B;
	m_Tooltip.DrawList[idx].t_color.A = 255;
}

//������� TooltipItem�� �߰��Ѵ�.
function AddTooltipItemBlank(int Height)
{
	StartItem();
	m_Info.eType = DIT_BLANK;
	m_Info.b_nHeight = Height;
	EndItem();
}

//��þƮ
function AddTooltipItemEnchant(ItemInfo Item)
{
	local EItemParamType eItemParamType;
	
	eItemParamType = EItemParamType(Item.ItemType);
	if (Item.Enchanted>0 && IsEnchantableItem(eItemParamType))
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		m_Info.t_strText = "+" $ Item.Enchanted $ " ";
		EndItem();
	}	
}

//������ �̸� + AdditionalName
function AddTooltipItemName(string Name, ItemInfo Item, int AddTooltipItemName)
{
	StartItem();
	m_Info.eType = DIT_TEXT;
	m_Info.t_bDrawOneLine = true;
	switch (AddTooltipItemName)
	{
		case 0:
		m_Info.t_color.R = 137;
		m_Info.t_color.G = 137;
		m_Info.t_color.B = 137;
		m_Info.t_color.A = 255;
		break;
		case 1:
		m_Info.t_color.R = 255;
		m_Info.t_color.G = 255;
		m_Info.t_color.B = 255;
		m_Info.t_color.A = 255;
		break;
		case 2:
		m_Info.t_color.R = 255;
		m_Info.t_color.G = 251;
		m_Info.t_color.B = 4;
		m_Info.t_color.A = 255;
		break;
		case 3:
		m_Info.t_color.R = 255;
		m_Info.t_color.G = 0;
		m_Info.t_color.B = 255;
		m_Info.t_color.A = 255;
		break;
	}
	m_Info.t_strText = Name;
	EndItem();
	
	//Additional Name
	if (Len(Item.AdditionalName)>0)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 255;
		m_Info.t_color.G = 217;
		m_Info.t_color.B = 105;
		m_Info.t_color.A = 255;
		m_Info.t_strText = " " $ Item.AdditionalName;
		EndItem();
	}
}

//Grade Mark
function AddTooltipItemGrade(ItemInfo Item)
{
	local string TextureName;
	
	TextureName = GetItemGradeTextureName(Item.CrystalType);
	//debug ("TextureName" @ TextureName);
	//debug (TextureName @  Item.CrystalType @ GetItemGradeTextureName(Item.CrystalType));
	if (Len(TextureName)>0)
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.nOffSetX = 2;
		m_Info.nOffSetY = 0;
		
		//S80 �׷��̵��� ��쿡 ���� ������ �ؽ��� ũ�⸦ 2��� �ø���.
		//debug ("�ؽ��� �̸�"@ Item.CrystalType );
		if (Item.CrystalType == 6 || Item.CrystalType == 7)
		{
			m_Info.u_nTextureWidth = 32;
			m_Info.u_nTextureHeight = 16;
			
			m_Info.u_nTextureUWidth = 32;
			m_Info.u_nTextureUHeight = 16;
			
			//debug (TextureName @  Item.CrystalType @ GetItemGradeTextureName(Item.CrystalType));
		}
		//��Ÿ �׷��̵忡 ���� ������ �ؽ��� ũ�⸦ �����Ѵ�. 
		else
		{
			m_Info.u_nTextureWidth = 16;
			m_Info.u_nTextureHeight = 16;
			
			m_Info.u_nTextureUWidth = 16;
			m_Info.u_nTextureUHeight = 16;
		}
		m_Info.u_strTexture = TextureName;
		EndItem();
	}
}

//Stackable Count
function AddTooltipItemCount(ItemInfo Item)
{
	if (IsStackableItem(Item.ConsumeType))
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strText = " (" $ MakeCostString(Int64ToString(Item.ItemNum)) $ ")";
		EndItem();
	}	
}

//���� ����
function GetRefineryColor(int Quality, out int R, out int G, out int B)
{
	switch (Quality)
	{
	case 1:
		R = 187;
		G = 181;
		B = 138;
	break;
	case 2:
		R = 132;
		G = 174;
		B = 216;
	break;
	case 3:
		R = 193;
		G = 112;
		B = 202;
	break;
	case 4:
		R = 225;
		G = 109;
		B = 109;
	break;
	default:
		R = 187;
		G = 181;
		B = 138;
	break;
	}
}

//�Ӽ� ������ �׷��ֱ�
function AddTooltipItemAttributeGage(ItemInfo Item)
{
	local int i;
	//local int highAttrValue[6];
	local Array<string> textureName, tooltipStr;
	
	for(i = 0; i < 6; i++)
	{
		textureName[i] = "";
		tooltipStr[i] = "";
	}
	
	NowAttrLv =0;
	NowMaxValue =0;
	NowValue =0;

	
	// ���� ������ �Ӽ�
	if (Item.AttackAttributeValue  > 0)
	{
		
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_FIRE);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_WATER);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_WIND);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_EARTH);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_HOLY);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_UNHOLY); //������ ���������� ���Ѵ�.
		
		switch(Item.AttackAttributeType)
		{
			case ATTRIBUTE_FIRE:
				textureName[ATTRIBUTE_FIRE] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_FIRE";
				tooltipStr[ATTRIBUTE_FIRE] =GetSystemString(1622) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_FIRE]) $ " ("$ GetSystemString(1622) $ " " $ GetSystemString(55) $ " " $ String(Item.AttackAttributeValue) $")";
				break;
			case ATTRIBUTE_WATER:
				textureName[ATTRIBUTE_WATER] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WATER";
				tooltipStr[ATTRIBUTE_WATER] =GetSystemString(1623) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_WATER]) $ " ("$ GetSystemString(1623) $ " " $ GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")";
				break;
			case ATTRIBUTE_WIND:
				textureName[ATTRIBUTE_WIND] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WIND";
				tooltipStr[ATTRIBUTE_WIND] =GetSystemString(1624) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_WIND]) $ " ("$ GetSystemString(1624) $ " " $ GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")";
				break;
			case ATTRIBUTE_EARTH:
				textureName[ATTRIBUTE_EARTH] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_EARTH";
				tooltipStr[ATTRIBUTE_EARTH] =GetSystemString(1625) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_EARTH]) $ " ("$ GetSystemString(1625) $ " " $ GetSystemString(55) $ " " $ String(Item.AttackAttributeValue) $")";
				break;
			case ATTRIBUTE_HOLY:
				textureName[ATTRIBUTE_HOLY] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DIVINE";
				tooltipStr[ATTRIBUTE_HOLY] =GetSystemString(1626) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_HOLY]) $ " ("$ GetSystemString(1626) $ " " $ GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")";
				break;
			case ATTRIBUTE_UNHOLY:
				textureName[ATTRIBUTE_UNHOLY] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DARK";
				tooltipStr[ATTRIBUTE_UNHOLY] =GetSystemString(1627) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_UNHOLY]) $ " ("$ GetSystemString(1627) $ " " $ GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")";
				break;
		}
	}
	else	// ��� ������ �Ӽ�
	{	
		SetDefAttribute(Item.DefenseAttributeValueFire,ATTRIBUTE_FIRE);
		SetDefAttribute(Item.DefenseAttributeValueWater,ATTRIBUTE_WATER);
		SetDefAttribute(Item.DefenseAttributeValueWind,ATTRIBUTE_WIND);
		SetDefAttribute(Item.DefenseAttributeValueEarth,ATTRIBUTE_EARTH);
		SetDefAttribute(Item.DefenseAttributeValueHoly,ATTRIBUTE_HOLY);
		SetDefAttribute(Item.DefenseAttributeValueUnholy,ATTRIBUTE_UNHOLY); //������ ���������� ���Ѵ�.

		if(Item.DefenseAttributeValueFire != 0) //���̾� �Ӽ� ���� �׸���
		{
			textureName[ATTRIBUTE_FIRE] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_FIRE";
			tooltipStr[ATTRIBUTE_FIRE] =GetSystemString(1623) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_FIRE]) $ " ("$ GetSystemString(1622) $ " " $ GetSystemString(54) $ " " $ String(Item.DefenseAttributeValueFire) $")";
		}
		if(Item.DefenseAttributeValueWater != 0) //�� �Ӽ� ���� �׸���
		{
			textureName[ATTRIBUTE_WATER] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WATER";
			tooltipStr[ATTRIBUTE_WATER] =GetSystemString(1622) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_WATER]) $ " ("$ GetSystemString(1623) $ " " $ GetSystemString(54) $ " " $String(Item.DefenseAttributeValueWater) $ ")";
		}
		if(Item.DefenseAttributeValueWind != 0) //�ٶ� �Ӽ� ���� �׸���
		{
			textureName[ATTRIBUTE_WIND] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WIND";
			tooltipStr[ATTRIBUTE_WIND] =GetSystemString(1625) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_WIND]) $ " ("$ GetSystemString(1624) $ " " $ GetSystemString(54) $ " " $String(Item.DefenseAttributeValueWind) $")";
		}
		if(Item.DefenseAttributeValueEarth != 0) //�� �Ӽ� ���� �׸���
		{
			textureName[ATTRIBUTE_EARTH] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_EARTH";
			tooltipStr[ATTRIBUTE_EARTH] =GetSystemString(1624) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_EARTH]) $ " ("$ GetSystemString(1625) $ " " $ GetSystemString(54) $ " " $String(Item.DefenseAttributeValueEarth) $ ")";
		}
		if(Item.DefenseAttributeValueHoly != 0) //�ż� �Ӽ� ���� �׸���
		{
			textureName[ATTRIBUTE_HOLY] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DIVINE";
			tooltipStr[ATTRIBUTE_HOLY] =GetSystemString(1627) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_HOLY]) $ " ("$ GetSystemString(1626) $ " " $ GetSystemString(54) $ " " $ String(Item.DefenseAttributeValueHoly) $")";
		}
		if(Item.DefenseAttributeValueUnholy != 0) //���� �Ӽ� ���� �׸���
		{
			textureName[ATTRIBUTE_UNHOLY] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DARK";
			tooltipStr[ATTRIBUTE_UNHOLY] =GetSystemString(1626) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_UNHOLY]) $ " ("$ GetSystemString(1627) $ " " $ GetSystemString(54) $ " " $String(Item.DefenseAttributeValueUnholy) $ ")";
		}
		// ��� ������ �Ӽ�
		

	}

	if (Item.AttackAttributeValue  > 0)//���ݼӼ��ϰ��
	{
		for(i = 0; i < 6; i++)
		{
			if(tooltipStr[i] == "") continue;			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 10;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_strText = tooltipStr[i];
			EndItem();
			
			//�ؽ��� ������ ���� �׷��� �Ѵ�. 
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = 2;
			m_Info.u_nTextureWidth = 140;
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = textureName[i] $ "_BG";
			EndItem();
			
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = -7;
			m_Info.u_nTextureWidth = AttackAttCurrValue[i] * 140 / AttackAttMaxValue[i] ;
			if( m_Info.u_nTextureWidth > 140) m_Info.u_nTextureWidth = 140;	//�Ѿ�� �� 140�̶��.. ��
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = textureName[i];
			EndItem();
		}
	
	}
	else{ //��� �Ӽ��� ���
		for(i = 0; i < 6; i++)
		{
			if(tooltipStr[i] == "") continue;			
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 10;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_strText = tooltipStr[i];
			EndItem();
			
			//�ؽ��� ������ ���� �׷��� �Ѵ�. 
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = 2;
			m_Info.u_nTextureWidth = 140;
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = textureName[i] $ "_BG";
			EndItem();
			
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = -7;
			
			m_Info.u_nTextureWidth = DefAttCurrValue[i] * 140 / DefAttMaxValue[i] ;
			if( m_Info.u_nTextureWidth > 140) m_Info.u_nTextureWidth = 140;	//�Ѿ�� �� 140�̶��.. ��
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = textureName[i];
			EndItem();
		}
	}
	
}

// function StartItem()
// {
// 	local DrawItemInfo infoClear;
// 	m_Info = infoClear;
// }
// 
// function EndItem()
// {
// 	m_Tooltip.DrawList.Length = m_Tooltip.DrawList.Length + 1;
// 	m_Tooltip.DrawList[m_Tooltip.DrawList.Length-1] = m_Info;
// }

//����Ʈ �������� ����Ʈ �̸� ǥ��
function AddTooltipItemQuestList(ItemInfo Item)
{
	local int i;
	
	//<���� ����Ʈ>
	if(Item.RelatedQuestID[0] != 0)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.nOffSetY = 10;
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strText = GetSystemString(1721);
		EndItem();
	}
	
	for(i = 0 ; i<MAX_RELATED_QUEST ; i++)
	{		
		if(Item.RelatedQuestID[i] != 0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 6;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_strText = class'UIDATA_QUEST'.static.GetQuestName(Item.RelatedQuestID[i]);;
			EndItem();
		}
	}
}


// �Ӽ��� �������� ���������� ����	//�ڷᰡ ���Ƽ� ���������� ����ִ´�. 

function SetAttackAttribute(int Attvalue, int type)
{
	if( AttValue >= 375)	// 9��	375 ~ 450
	{
		AttackAttLevel[type] = 9;
		AttackAttMaxValue[type] = 75;
		AttackAttCurrValue[type] = AttValue - 375;
	}
	else if( AttValue >= 325)	// 8��	325 ~ 375
	{
		AttackAttLevel[type] = 8;
		AttackAttMaxValue[type] = 50;
		AttackAttCurrValue[type] = AttValue - 325;
	}
	else if( AttValue >= 300)	// 7��	300 ~ 325
	{
		AttackAttLevel[type] = 7;
		AttackAttMaxValue[type] = 25;
		AttackAttCurrValue[type] = AttValue - 300;
	}
	else if( AttValue >= 225)	// 6��	225 ~ 300
	{
		AttackAttLevel[type] = 6;
		AttackAttMaxValue[type] = 75;
		AttackAttCurrValue[type] = AttValue - 225;
	}
	else if( AttValue >= 175)	// 5��	175 ~ 225
	{
		AttackAttLevel[type] = 5;
		AttackAttMaxValue[type] = 50;
		AttackAttCurrValue[type] = AttValue - 175;
	}
	else if( AttValue >= 150)	// 4��	150 ~ 175
	{
		AttackAttLevel[type] = 4;
		AttackAttMaxValue[type] = 25;
		AttackAttCurrValue[type] = AttValue - 150;
	}
	else if( AttValue >= 75)	// 3��	75 ~ 150
	{
		AttackAttLevel[type] = 3;
		AttackAttMaxValue[type] = 75;
		AttackAttCurrValue[type] = AttValue - 75;
	}
	else if( AttValue >= 25)	// 2��	25~ 75
	{
		AttackAttLevel[type] = 2;
		AttackAttMaxValue[type] = 50;
		AttackAttCurrValue[type] = AttValue - 25;
	}
	else	// else 0~ 25
	{
		AttackAttLevel[type] = 1;
		AttackAttMaxValue[type] = 25;
		AttackAttCurrValue[type] = AttValue;
	}	
}
// �Ӽ��� �������� ���������� ����	//�ڷᰡ ���Ƽ� ���������� ����ִ´�. 


function SetDefAttribute(int Defvalue, int type)
{
	if( DefValue >= 150)	// 9��		150~180
	{
		DefAttLevel[type] = 9;
		DefAttMaxValue[type] = 30;
		DefAttCurrValue[type] = DefValue - 150;
	}
	else if( DefValue >= 132)	// 8��	132 ~ 150
	{
		DefAttLevel[type] = 8;
		DefAttMaxValue[type] = 18;
		DefAttCurrValue[type] = DefValue - 132;
	}
	else if( DefValue >= 120)	// 7��	120 ~ 132
	{
		DefAttLevel[type] = 7;
		DefAttMaxValue[type] = 12;
		DefAttCurrValue[type] = DefValue - 120;
	}
	else if( DefValue >= 90)	// 6��	90 ~ 120
	{
		DefAttLevel[type] = 6;
		DefAttMaxValue[type] = 30;
		DefAttCurrValue[type] = DefValue - 90;
	}
	else if( DefValue >= 72)	// 5��	72 ~ 90
	{
		DefAttLevel[type] = 5;
		DefAttMaxValue[type] = 18;
		DefAttCurrValue[type] = DefValue - 72;
	}
	else if( DefValue >= 60)	// 4��	60 ~ 72
	{
		DefAttLevel[type] = 4;
		DefAttMaxValue[type] = 12;
		DefAttCurrValue[type] = DefValue - 60;
	}
	else if( DefValue >= 30)	// 3��	30 ~ 60
	{
		DefAttLevel[type] = 3;
		DefAttMaxValue[type] = 30;
		DefAttCurrValue[type] = DefValue - 30;
	}
	else if( DefValue >= 12)	// 2��	// 12 ~ 30
	{
		DefAttLevel[type] = 2;
		DefAttMaxValue[type] = 18;
		DefAttCurrValue[type] = DefValue - 12;
	}
	else	// else				// 0~ 12
	{
		DefAttLevel[type] = 1;
		DefAttMaxValue[type] = 12;
		DefAttCurrValue[type] = DefValue;
	}	
}

//branch
function AddPrimeItemSymbol(ItemInfo Item)
{
	local string TextureName;

	if (Item.IsBRPremium != 2)
		return;

	TextureName = GetPrimeItemSymbolName();
	if (Len(TextureName)>0)
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.nOffSetX = 2;
		m_Info.nOffSetY = 0;
		
		m_Info.u_nTextureWidth = 16;
		m_Info.u_nTextureHeight = 16;
			
		m_Info.u_nTextureUWidth = 16;
		m_Info.u_nTextureUHeight = 16;

		m_Info.u_strTexture = TextureName;
		EndItem();
	}
}
//end of branch
defaultproperties
{
}
