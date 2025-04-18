/**
*�̴ϸ�(����) ��Ʈ�ѿ� ���� �Լ��Դϴ�
*/
class MinimapCtrlHandle extends WIndowHandle
	native;

/**
* ���� �������� ��ġ�� �ٲ۴�

* @param
* Loc : �������� ��ġ(����)
* a_ZoomToTownMap(optional) : ���������� ���Ѵ�.
* a_UserGridLocation(optional) : GridLocation�� ����Ѵ�??

* @return
* void

* @example
* var  MinimapCtrlHandle t_handle;
* var vector Location;
* Location.x = -86916;
* Location.y = 222183;
* Location.z = -4656;
* t_handle = GetMinimapCtrlHandle( "MinimapWnd.Minimap" ); //�ڵ��� �����´�
* t_handle.AdjustMapView(Location); // (-86916, 222183, -4656) ��ġ�� ������� ����
*/
native final function AdjustMapView( vector Loc, optional bool a_ZoomToTownMap, optional bool a_UseGridLocation );
//native final function InitPosition();

/**
* ������ Ÿ���� �߰��Ѵ�.(����� ������ ǥ�õȴ�)

* @param
* Loc : Ÿ���� ��ġ(����)

* @return
* void

* @example
* var  MinimapCtrlHandle t_handle;
* var vector Location;
* Location.x = -86916;
* Location.y = 222183;
* Location.z = -4656;
* t_handle = GetMinimapCtrlHandle( "MinimapWnd.Minimap" ); //�ڵ��� �����´�
* t_handle.AddTarget(Location); // (-86916, 222183, -4656) ��ġ�� Ÿ���� �߰��Ѵ�
*/
native final function AddTarget( vector a_Loc );

/**
* ������ Ÿ���� �����Ѵ�.

* @param
* Loc : Ÿ���� ��ġ(����)

* @return
* void

* @example
* var  MinimapCtrlHandle t_handle;
* var vector Location;
* Location.x = -86916;
* Location.y = 222183;
* Location.z = -4656;
* t_handle = GetMinimapCtrlHandle( "MinimapWnd.Minimap" ); //�ڵ��� �����´�
* t_handle.AddTarget(Location); // (-86916, 222183, -4656) ��ġ�� Ÿ���� �߰��Ѵ�
* t_handle.DeleteTarget(Location); // ����߰��� Ÿ���� �����
*/
native final function DeleteTarget(  vector a_Loc );

/**
* ������ ��� Ÿ���� �����Ѵ�.

* @param
* void

* @return
* void

* @example
* var  MinimapCtrlHandle t_handle;
* var vector Location;
* Location.x = -86916;
* Location.y = 222183;
* Location.z = -4656;
* t_handle = GetMinimapCtrlHandle( "MinimapWnd.Minimap" ); //�ڵ��� �����´�
* t_handle.AddTarget(Location); // (-86916, 222183, -4656) ��ġ�� Ÿ���� �߰��Ѵ�
* t_handle.DeleteAllTarget(); // �ʻ��� ��� Ÿ���� (��� �߰��� ���� �����Ͽ�) �����
*/
native final function DeleteAllTarget();

/**
* �ʻ� ����Ʈ ǥ�ø� �������� ���θ� �����ѵ�

* @param
* a_ShowQuest : true �� ������, false�� �Ⱥ�����

* @return
* void

* @example
* var  MinimapCtrlHandle t_handle;
* var vector Location;
* Location.x = -86916;
* Location.y = 222183;
* Location.z = -4656;
* t_handle = GetMinimapCtrlHandle( "MinimapWnd.Minimap" ); //�ڵ��� �����´�
* t_handle.SetShowQuest(true); //����Ʈ ǥ�ø� �����ش�
*/
native final function SetShowQuest( bool a_ShowQuest );

/**
* �����������Ʈ�� �����ϰ� �ֵ��� �����Ѵ� 

* @param
* a_SSQStatus :  

* @return
* void

* @example
* var  MinimapCtrlHandle t_handle;
* t_handle = GetMinimapCtrlHandle( "MinimapWnd.Minimap" ); //�ڵ��� �����´�
* t_handle.SetSSQStatus(0); // �����Ѵ�(������ �ǹ̴�?)
*/
native final function SetSSQStatus( int a_SSQStatus );
native final function DrawGridIcon( string a_IconName, string a_DupIconName, vector a_Loc, bool a_Refresh, optional int a_XOffset, optional int a_YOffset, optional string TooltipString );
native final function RequestReduceBtn();
native final function bool IsOverlapped( int FirstX, int FirstY, int SecondX, int SecondY);
native final function DeleteAllCursedWeaponIcon();
native final function AddRegionInfo( string RegionInfo );
native final function UpdateRegionInfo( int idx, string RegionInfo );
native final function EraseAllRegionInfo();
native final function EraseRegionInfo(int index);
native final function SetContinent(int Continent);
//native final function TestMove(int X, int y);
defaultproperties
{
}
