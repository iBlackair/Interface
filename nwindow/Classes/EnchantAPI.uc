class EnchantAPI extends UIEventManager
	native;
	
native static function RequestEnchantItem(ItemID a_sTargetID, ItemID a_sSupportID);
native static function RequestEnchantItemAttribute(ItemID sID);
native static function RequestRemoveAttribute(ItemID sID, int type);

// 아이템 인첸트 Ver2, ttmayrin
native static function RequestExTryToPutEnchantTargetItem( ItemID a_sTargetID );
native static function RequestExTryToPutEnchantSupportItem( ItemID a_sTargetID, ItemID a_sSupportID );
native static function RequestExCancelEnchantItem();
defaultproperties
{
}
