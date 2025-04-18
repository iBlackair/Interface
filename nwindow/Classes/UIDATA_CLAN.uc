class UIDATA_CLAN extends UIDataManager
	native;

native static function string GetName(int ID);
native static function string GetAllianceName(int ID);
native static function bool GetCrestTexture(int ID, out texture texCrest);
native static function bool GetEmblemTexture(int ID, out texture emblemTexture);
native static function bool GetAllianceCrestTexture(int ID, out texture texCrest);
native static function bool	GetNameValue( int ID, out int namevalue );
native static function RequestClanInfo();		// ��ü ���� ������ �ʱ�ȭ �ϰ� ���� Ŭ���̾�Ʈ���� ������ ���� �ش�.
native static function RequestClanSkillList();
native static function RequestSubClanSkillList(int subClanIndex);
native static function int GetSkillLevel(int skillID);
native static function int GetSubClanSkillLevel(int skillID, int subClanIndex);
defaultproperties
{
}
