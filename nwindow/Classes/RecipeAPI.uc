class RecipeAPI extends UIEventManager
	native;

native static function RequestRecipeShopMakeInfo( int nServerID, int nRecipeID );
native static function RequestRecipeShopSellList( int nServerID );
native static function RequestRecipeShopMakeDo( int MerchantID, int RecipeID, INT64 Adena);
native static function RequestRecipeItemMakeSelf( int RecipeID );
native static function RequestRecipeItemMakeInfo( ItemID sID );
native static function RequestRecipeBookOpen( int Type );
native static function RequestRecipeItemDelete( ItemID sID );
native static function RequestRecipeShopManageQuit();
native static function RequestRecipeShopMessageSet( string strMsg );
native static function RequestRecipeShopListSet( string param );
defaultproperties
{
}
