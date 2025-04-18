class UIDATA_ITEM extends UIDataManager
	native;

native static function ItemID GetFirstID();
native static function ItemID GetNextID();
native static function int GetDataCount();
native static function string GetItemName(ItemID Id);
native static function string GetItemAdditionalName(ItemID Id);
native static function string GetItemTextureName(ItemID Id);
native static function string GetItemDescription(ItemID Id);
native static function int GetItemWeight(ItemID Id);
native static function int GetItemDataType(ItemID Id);
native static function int GetItemCrystalType(ItemID Id);
native static function bool GetItemInfo(ItemID Id, out ItemInfo info );
native static function bool IsCrystallizable(ItemID Id);
native static function string GetRefineryItemName(string strItemName, int RefineryOp1, int RefineryOp2);
native static function int GetSetItemNum(ItemID Id, int setIdId);
native static function bool IsExistSetItem(ItemID Id, int setId, int index);
native static function int GetSetItemFirstID(ItemID Id, int setId, int index);
native static function bool GetSetItemID(ItemID Id, int setId, int index, out array<ItemID> arrID);
native static function int GetSetItemEnchantValue(ItemID Id);
native static function string GetSetItemEffectDescription(ItemID Id, int EffectID );
native static function string GetSetItemEnchantEffectDescription(ItemID Id);
native static function string GetEtcItemTextureName(ItemID Id);

//보급,고급형 아이템, ttmayrin
native static function int GetItemNameClass(ItemID Id);
defaultproperties
{
}
