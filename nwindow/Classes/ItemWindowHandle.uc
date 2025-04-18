/**
*������������ �ڵ鿡 ���� �Լ��� �����Ѵ�
*/
class ItemWindowHandle extends WindowHandle native;

/**
* ���õ� �������� ��ȣ(��Ʈ�ѿ����� ��ġ��ȣ)�� �����Ѵ�

* @param
* void

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*debug(string(i_handle.GetSelectedNum())); //���õ� �������� ��ȣ�� ����Ѵ�
*/
native final function int GetSelectedNum();

/**
*������������ ��Ʈ���� �� �����۽��Լ��� �����Ѵ�.

* @param
* void

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*debug(string(i_handle.GetItemNum())); //������������ ��Ʈ���� �ѽ��� ���� ����Ѵ�(�κ��� ��� 80�̾���)
*/
native final function int GetItemNum();

/**
*�����ۼ����� ����Ѵ�

* @param
* void

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.ClearSelect(); //������ ����Ѵ�
*/
native final function ClearSelect();

/**
*�������� �߰��Ѵ�

* @param
* info : �߰��� �������� ��������ü

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var ItemInfo info;
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.GetItem(0, info); //0�� �������� �����´�
*I_handle.AddItem(info); //0���������� �ϳ��� �߰��Ѵ�. 

*struct native constructive ItemInfo
*{
*	var ItemID Id;
*	var string Name;
*	var string AdditionalName;
*	var string IconName;
*	var string IconNameEx1;
*	var string IconNameEx2;
*	var string IconNameEx3;
*	var string IconNameEx4;
*	var string ForeTexture;
*	var string Description;
*	var string DragSrcName;
*	var string IconPanel;
*	var int DragSrcReserved;
*	var string MacroCommand;
*	var int ItemType;
*	var int ItemSubType;
*	var INT64 ItemNum;
*	var INT64 Price;
*	var int Level;
*	var int SlotBitType;
*	var int Weight;
*	var int MaterialType;
*	var int WeaponType;
*	var int PhysicalDamage;
*	var int MagicalDamage;
*	var int PhysicalDefense;
*	var int MagicalDefense;
*	var int ShieldDefense;
*	var int ShieldDefenseRate;
*	var int Durability; 
*	var int CrystalType;
*	var int RandomDamage;
*	var int Critical;
*	var int HitModify;
*	var int AttackSpeed;
*	var int MpConsume;
*	var int ArmorType;
*	var int AvoidModify;
*	var int Damaged;
*	var int Enchanted;
*	var int MpBonus;
*	var int SoulshotCount;
*	var int SpiritshotCount;
*	var int PopMsgNum;
*	var int BodyPart;
*	var int RefineryOp1;
*	var int RefineryOp2;
*	var int CurrentDurability;
*	var int CurrentPeriod;
*	// [ĥ��ĥ��, �� ����] item enchant option - by jin 09/08/05
*	var int EnchantOption1;
*	var int EnchantOption2;
*	var int EnchantOption3;
*	//
*	var int Reserved;
*	var INT64 Reserved64;
*	var INT64 DefaultPrice;
*	var int ConsumeType;
*	var int Blessed;
*	var INT64 AllItemCount;
*	var int IconIndex;
*	var bool bEquipped;
*	var bool bRecipe;  
*	var bool bArrow; 
*	var bool bShowCount;
*	var bool bDisabled;
*	var bool bIsLock;
*	var int AttackAttributeType;		// �Ӽ� - lancelot 2007. 4.27.
*	var int AttackAttributeValue;
*	var int DefenseAttributeValueFire;
*	var int DefenseAttributeValueWater;
*	var int DefenseAttributeValueWind;
*	var int DefenseAttributeValueEarth;
*	var int DefenseAttributeValueHoly;
* 	var int DefenseAttributeValueUnholy;
*	var int RelatedQuestID[MAX_RELATED_QUEST];
*};
*/
native final function AddItem(ItemInfo info);

native final function AddItemWithFaded(ItemInfo info);
/**
*�������� �ش� �ε����� �߰��Ѵ�.

* @param
* index : �ε���
* info : �������� ���� ����ü

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var ItemInfo info;
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.GetItem(0, info); //0�� �������� �����´�
*I_handle.SetItem(1, info); //0���������� 1�� ���Կ� �ϳ��� �߰��Ѵ�. 
*/
native final function bool SetItem(int index, ItemInfo info);

/**
*�ش� �ε����� �������� �����

* @param
* index : �ε���
* info : �������� ���� ����ü

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var ItemInfo info;
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.DeleteItem(0); // 0�� �ε����� �������� �����
*/
native final function DeleteItem(int index);

/**
*���õ� �������� ������ �����´�

* @param
* info : �������� ������ ��ƿ� ����ü

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var ItemInfo info;
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.GetSelectedItem(info); //info�� ���õ� �������� ������ �Ѿ�´�
*/
native final function bool GetSelectedItem(out ItemInfo info);

/**
*������ �ε����� �������� ������ �����´�

* @param
* index : ������ �ε���(�»�ܺ��� 0��)
* info : �������� ������ ��ƿ� ����ü

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var ItemInfo info;
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.GetItem(0,info); //info�� ���»���� �������� ������ �Ѿ�´�
*/
native final function bool GetItem(int index, out ItemInfo info);

/**
*�������� ��������

* @param
* void

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var ItemInfo info;
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.Clear(); //�������
*/
native final function Clear();

/**
*�������� ���̵� ���� ã�� �ε����� �������Ѵ�(������ -1)
*���̵�(ItemID sdID)�� �������̵�� Ŭ�������̵�� �̷���� ����ü(struct native constructive ItemID)�ε� �Ѵ� �����ϸ� �Ѵ� ��ġ�ϴ� ���� ã��
*���� �ϳ��� ���ϰ� �������� 0���� �θ� �� �ϳ��� �������� ã�´�.

* @param
* scID : ���̵� ����ü

* @return
* int : �������� �ε���

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var int index;
*var ItemID item_id;
*item_id.ServerID = 100; //�������۸��� ������ ���̵�
*item_id.ClassID = 100; //�����̸��� �������� �����ϴ� ���̵�

*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*index = i_handle.Finditem(item_id); //�������� ���̵� ���� ã�´�. �ε����� �����Ѵ�

*struct native constructive ItemID
*{
*	var int ClassID;
*	var int ServerID;
*};
*/
native final function int FindItem( ItemID scID );

/**
*�������� �־��� ������������ ���� �������� ã�� �ε����� �������Ѵ�(������ -1)
*��������� ���ҵ��� �̸������� ��� �׷����� �ʴ�. ���� ������� �ڵ带 ��������
*����(iteminfo)�ȿ� �����ϴ� ����� ���̵�(ItemID Id)�� �������̵�� Ŭ�������̵�� �̷���� ����ü�ε� �Ѵ� �����ϸ� �Ѵ� ��ġ�ϴ� ���� ã��
*���� �ϳ��� ���ϰ� �������� 0���� �θ� �� �ϳ��� �������� ã�´�.
*���λ������� ���ȹ��ִ�. ���λ������� ������ �����Ϸ� �鶧 �ڽ��� ���� �����۸� Ȱ��ȭ�Ǵµ� �׶� ����ѵ� �ϴ�

* @param
* info : ����������

* @return
* int : �������� �ε���

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var int index;
*var ItemInfo info;
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*index = i_handle.FinditemWithAllProperty(info); //�������� ������ ���� ã�´�. �ε����� �����Ѵ�

*struct native constructive ItemID
*{
*	var int ClassID;
*	var int ServerID;
*};

*struct native constructive ItemInfo
*{
*	var ItemID Id; 
*	var string Name;
*	var string AdditionalName;
*	var string IconName;
*	var string IconNameEx1;
*	var string IconNameEx2;
*	var string IconNameEx3;
*	var string IconNameEx4;
*	var string ForeTexture;
*	var string Description;
*	var string DragSrcName;
*	var string IconPanel;
*	var int DragSrcReserved;
*	var string MacroCommand;
*	var int ItemType;
*	var int ItemSubType;
*	var INT64 ItemNum;
*	var INT64 Price;
*	var int Level;
*	var int SlotBitType;
*	var int Weight;
*	var int MaterialType;
*	var int WeaponType;
*	var int PhysicalDamage;
*	var int MagicalDamage;
*	var int PhysicalDefense;
*	var int MagicalDefense;
*	var int ShieldDefense;
*	var int ShieldDefenseRate;
*	var int Durability; 
*	var int CrystalType;
*	var int RandomDamage;
*	var int Critical;
*	var int HitModify;
*	var int AttackSpeed;
*	var int MpConsume;
*	var int ArmorType;
*	var int AvoidModify;
*	var int Damaged;
*	var int Enchanted;
*	var int MpBonus;
*	var int SoulshotCount;
*	var int SpiritshotCount;
*	var int PopMsgNum;
*	var int BodyPart;
*	var int RefineryOp1;
*	var int RefineryOp2;
*	var int CurrentDurability;
*	var int CurrentPeriod;
*	// [ĥ��ĥ��, �� ����] item enchant option - by jin 09/08/05
*	var int EnchantOption1;
*	var int EnchantOption2;
*	var int EnchantOption3;
*	//
*	var int Reserved;
*	var INT64 Reserved64;
*	var INT64 DefaultPrice;
*	var int ConsumeType;
*	var int Blessed;
*	var INT64 AllItemCount;
*	var int IconIndex;
*	var bool bEquipped;
*	var bool bRecipe;  
*	var bool bArrow; 
*	var bool bShowCount;
*	var bool bDisabled;
*	var bool bIsLock;
*	var int AttackAttributeType;		// �Ӽ� - lancelot 2007. 4.27.
*	var int AttackAttributeValue;
*	var int DefenseAttributeValueFire;
*	var int DefenseAttributeValueWater;
*	var int DefenseAttributeValueWind;
*	var int DefenseAttributeValueEarth;
*	var int DefenseAttributeValueHoly;
* 	var int DefenseAttributeValueUnholy;
*	var int RelatedQuestID[MAX_RELATED_QUEST];
*};

*����� ���ϴ� �κ��� �ڵ�� ����������(�̰��� �������̵� �����Ѱ��)
*if( pWnd->GetItem(i)->m_iServerID==itemInfo->Id.ServerID &&  pWnd->GetItem(i)->m_iEnchanted == itemInfo->Enchanted
*					&& pWnd->GetItem(i)->m_Attribute.AttackType == (SHORT)itemInfo->AttackAttributeType && pWnd->GetItem(i)->m_Attribute.AttackValue == (SHORT)itemInfo->AttackAttributeValue
*					&& pWnd->GetItem(i)->m_Attribute.DefenseValue[ATTRT_FIRE] == (SHORT)itemInfo->DefenseAttributeValueFire && pWnd->GetItem(i)->m_Attribute.DefenseValue[ATTRT_WATER] == (SHORT)itemInfo->DefenseAttributeValueWater
*					&& pWnd->GetItem(i)->m_Attribute.DefenseValue[ATTRT_WIND] == (SHORT)itemInfo->DefenseAttributeValueWind && pWnd->GetItem(i)->m_Attribute.DefenseValue[ATTRT_EARTH] == (SHORT)itemInfo->DefenseAttributeValueEarth
*					&& pWnd->GetItem(i)->m_Attribute.DefenseValue[ATTRT_HOLY] == (SHORT)itemInfo->DefenseAttributeValueHoly && pWnd->GetItem(i)->m_Attribute.DefenseValue[ATTRT_UNHOLY]== (SHORT)itemInfo->DefenseAttributeValueUnholy)
*/
native final function int FindItemWithAllProperty(ItemInfo info);

/**
*�������� m_iReserved��� ������ ����Ͽ� ã�´�(�ε����� �����Ѵ�)
*m_iReserved�� NCitemŬ����(�������� ��Ÿ���� Ŭ����)�� ����� ���������� ����Ǿ��ִ�
*INT  m_iReserved;  //when user (deposit, withdraw) item, temporary used for DB ID 
*��, â�� �±�ų� ��ã���� �����ۿ� �ο��Ǵ� ���ϰ� �Ǵ� ������ȣ�� �Ҽ��ְڴ�
*�׷��� ������ ���� �κ��� ����

* @param
* Reserved : �������� ���ϰԵǴ� �Ͻ��� DB���̵�

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var int index;
*i_handle = GetItemWindowHandle("WarehouseWnd.TopList"); //����â���� �ڵ�
*index = i_handle.FindItemWithReserved(125); //125���� ã�´�
*/
native final function int FindItemWithReserved(int Reserved);

/**
* ��ü ������������ ��Ʈ���� �������� �Ѵ�.(Ȥ�� ����Ѵ�)

* @param
* bOn : true�� ����, false �� ��������

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.SetFaded(true);//���������Ѵ�
*/
native final function SetFaded( bool bOn );

/**
* ��ũ�ѹٸ� �����ְų� ���ش�

* @param
* bShow : true�� ������, false �� �Ⱥ�����

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.ShowScrollBar(true);//��ũ�ѹٸ� �����ش� 
*/
native final function ShowScrollBar(bool bShow);

/**
* ������ �ΰ��� ����(�¹ٲ�)�Ѵ�

* @param
* index1 : �ٲ������1 �ε���
* index2 : �ٲ������2 �ε���

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.SwapItems(0,1); //0���� 1���������� �����Ѵ� 
*/
native final function SwapItems(int index1, int index2);

/**
* ������ ��ġ�� �������� ��ġ�ϴ� ���� ������ĭ�� �ε����� �����Ѵ�.

* @param
* x : x��ġ (�����쿡���� ��ġ�� �ƴ� ��üȭ���� ��ǥ���̴�)
* y : y��ġ
* offsetX : x���� ������
* offsetY : y���� ������

* @return
* int : ������ĭ�� �ε���

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*debug(string(GetIndexAt(1000,10000,0,0))); // (1000,1000) + (0,0) ����ġ�� �ε����� ����Ѵ�.
*/
native final function int	GetIndexAt( int x, int y, int offsetX, int offsetY );

/**
* ������ ��ġ�� �������� ��ġ�ϴ� ���� ������ĭ�� �ε����� �����Ѵ�.

* @param
* x : x��ġ (�����쿡���� ��ġ�� �ƴ� ��üȭ���� ��ǥ���̴�)
* y : y��ġ
* offsetX : x���� ������
* offsetY : y���� ������

* @return
* int : ������ĭ�� �ε���

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*debug(string(GetIndexAt(1000,10000,0,0))); // (1000,1000) + (0,0) ����ġ�� �ε����� ����Ѵ�.
*/
native final function SetDisableTex( String a_DisableTex );

/**
* ������������ ��Ʈ���� ���� �����Ѵ�.

* @param
* a_Row : ���

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.SetRow(1); //���� 1������ �����Ѵ�
*/
native final function SetRow( int a_Row );

/**
* ������������ ��Ʈ���� ���� �����Ѵ�.

* @param
* a_Col : ����

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.SetCol(1); //���� 1������ �����Ѵ�
*/
native final function SetCol( int a_Col );

/**
* �⺻�������������� ���� �̿ܿ� �߰����� ������ �÷��ش�
* ��������������Ʈ���� m_ExpandItemArray �̶�� ���� �����ϴµ� ���⿡ ������ �Ŵ޸���.
* m_ExpandItemArray�� ����� index�� ���ϴµ� �� ����� �����Ǿ� �־ index�� 0�� �����ϴ�.
* �����ǵ������� �˼������� ������ ���� �κе� index�� 0�� �͹ۿ� ����.
* ���ӻ󿡼� �߰��κ��� ����� ����� �Ѱ������ΰ�? ��ư �׷����ϴ�. ������ �߸���..

* @param
* index : �߰������� �ε���(0�� �Ǵ���)
* num : �ε����� �þ ������ ����

* @return
* void

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*i_handle.SetExpandItemNum(0,3); //3���� �߰������� ����. m_ExpandItemArray�� 0��° �ε����� �� ������ �����Ѵ�
*/
native final function SetExpandItemNum(int index, int num);

/**
*?????
*/
native final function SetItemUsability();

/**
* �������� ��Ʈ�ѳ��� �ε����� classID�� ���� ã�´�(����������)

* @param
* scID : ���̵�����

* @return
* int : �������� �ε���

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var int index;
*var ItemId id;
*id.ClassID = 1000;
*i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
*index = i_handle.FindItemByClassID(id); //Ŭ����id�� 1000�� �������� ��Ʈ�ѳ��� �ε����� ã�´�

*struct native constructive ItemID
*{
*	var int ClassID;
*	var int ServerID;
*};
*/
native final function int FindItemByClassID(ItemID scID);

/**
* �������� ��Ʈ���� ���鶧 xml���� type�� sidebuttontype�����ϸ� prev next��ư�� �ִ� �������� travel�Ҽ��ִ� ��Ʈ���� �����
* �׶� ��ü ���������� �����Ѵ�. �� �������� 100���ε� �ѹ��� �������°� 20�̸� 5�� ���ϵȴ�

* @param
* void 

* @return
* int : ����������

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var pagenum;
*i_handle = GetItemWindowHandle("PostWriteWnd.InventoryItem");
*pagenum = i_handle.GetSideTypePageNum(); //�� �������� ����
*/
native final function int GetSideTypePageNum();

/**
* �������� ��Ʈ���� ���鶧 xml���� type�� sidebuttontype�����ϸ� prev next��ư�� �ִ� �������� travel�Ҽ��ִ� ��Ʈ���� �����
* �׶� ���� ������ ��ġ�� �����Ѵ�.

* @param
* void 

* @return
* int : ������������

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*var pagenum;
*i_handle = GetItemWindowHandle("PostWriteWnd.InventoryItem");
*pagenum = i_handle.GetSideTypeCurPage(); //���������� ��ġ�� ����
*/
native final function int GetSideTypeCurPage();

/**
* �������� ��Ʈ���� ���鶧 xml���� type�� sidebuttontype�����ϸ� prev next��ư�� �ִ� �������� travel�Ҽ��ִ� ��Ʈ���� �����
* �׶� prev��ư�� ������

* @param
* void 

* @return
* int : ������������

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("PostWriteWnd.InventoryItem");
*i_handle.PushSideTypePrevBtn(); // ���������� �̵�
*/
native final function PushSideTypePrevBtn();

/**
* �������� ��Ʈ���� ���鶧 xml���� type�� sidebuttontype�����ϸ� prev next��ư�� �ִ� �������� travel�Ҽ��ִ� ��Ʈ���� �����
* �׶� next��ư�� ������

* @param
* void 

* @return
* int : ������������

* @example
*var ItemWindowHandle i_handle; //������ �ڵ� ����
*i_handle = GetItemWindowHandle("PostWriteWnd.InventoryItem");
*i_handle.PushSideTypeNextBtn(); // ���������� �̵�
*/
native final function PushSideTypeNextBtn();

native final function SetSelectedNum(int idx);
defaultproperties
{
}
