class UIAPI_LISTCTRL extends UIAPI_WINDOW 
	native;
native static function InsertRecord(string ControlName,LVDataRecord Record);
native static function BOOL ModifyRecord(string ControlName, int index, LVDataRecord Record);		// Ư�����ڵ带 ���� - lancelot 2006. 10. 18.
native static function DeleteAllItem(string ControlName);
native static function DeleteRecord(string ControlName,int index);
native static function int GetRecordCount(string ControlName);
native static function int GetSelectedIndex(string ControlName);
native static function SetSelectedIndex(string ControlName, int index, bool bMoveToRow);
native static function ShowScrollBar(string ControlName, bool bShow);
defaultproperties
{
}
