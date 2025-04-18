class UIDATA_SKILL extends UIDataManager
	native;

native static function ItemID GetFirstID();
native static function ItemID GetNextID();
native static function int GetDataCount();
native static function string GetIconName( ItemID ID, int level );
native static function string GetName( ItemID ID, int level );
native static function string GetDescription( ItemID ID, int level );
native static function string GetEnchantName( ItemID ID, int level );
native static function int GetEnchantSkillLevel( ItemID ID, int level );
native static function string GetEnchantIcon( ItemID ID, int level );
native static function string GetOperateType( ItemID ID, int level );
native static function int GetHpConsume( ItemID ID, int level );
native static function int GetMpConsume( ItemID ID, int level );
native static function int GetCastRange( ItemID ID, int level );
defaultproperties
{
}
