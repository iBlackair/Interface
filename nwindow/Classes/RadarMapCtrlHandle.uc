/**
*���̴�����Ʈ�ѿ� ���� �Լ��� ����
*/
class RadarMapCtrlHandle extends WindowHandle
	native;
/**
* ���̴��� ǥ�õǴ� ��ü�� �߰��Ѵ�. ���̴� ��Ʈ���� ���ο� Tarray�� �� ��ü(NCRadarObjectCtrl) ����Ʈ�� �����ϴµ�
* ���⿡ ���̴��� ǥ�õ� ��ü�� �迭�� �����Ѵ�. 

* @param
* ID : ��ü�� ID 
* Type : ��ü�� type (���� "PartyMember", "Monster", "Target", "Quest", "Clan" �� �ִ�)
* Name : ��ü�� �̸�(���̴� �ʿ� �������� ǥ�õȴ�)
* locX : ��ü�� ���� x��ǥ. ��ü�� ��ġ�� ���� ������ �����Ѵ�. GetTargetInfo(UIScript.uc ����) �� ���� �̸� ������ API�� ����ϰų� �ʿ俩�Ͽ� ���� ���ο� API�� �ۼ��ϵ��� ����.
* locY : ��ü�� ���� y��ǥ
* locZ : ��ü�� ���� z��ǥ
*
* @return
* void

* @example
* var RadarMapCtrlHandle r_handle;
* r_handle = GetRadarMapCtrlHandle("RadarMapWnd.RadarMapCtrl"); //�ڵ��� �����´�
* r_handle.AddObject(100,"PartyMember", "Sohee", -93365, 238772, -3510); //(-93365,238772,-3510)�� WC�� �츮 ���� ��Ƽ����� ǥ���ϵ��� �߰��Ѵ�
*/
native final function AddObject( int ID, string Type, string Name, int locX, int locY, int locZ );

/**
* ���̴��� ǥ�õǴ� ��ü�� �����Ѵ�.

* @param
* ID : ������ ��ü�� ID

* @return
* void

* @example
* var RadarMapCtrlHandle r_handle;
* r_handle = GetRadarMapCtrlHandle("RadarMapWnd.RadarMapCtrl"); //�ڵ��� �����´�
* r_handle.AddObject(100,"PartyMember", "Sohee", -93365, 238772, -3510); //(-93365,238772,-3510)�� WC�� �츮 ���� ��Ƽ����� ǥ���ϵ��� �߰��Ѵ�
* r_handle.DeleteObject(100); //�������� �츮 ���� �����Ͽ���
*/
native final function DeleteObject( int ObjectID );

/**
* ���̴��� ǥ�õǴ� ��ü�� ��ġ�� �����Ѵ�.

* @param
* ID : ������ ��ü�� ID
* locX : ��ü�� ���� x��ǥ. ��ü�� ��ġ�� ���� ������ �����Ѵ�. GetTargetInfo(UIScript.uc ����) �� ���� �̸� ������ API�� ����ϰų� �ʿ俩�Ͽ� ���� ���ο� API�� �ۼ��ϵ��� ����.
* locY : ��ü�� ���� y��ǥ
* locZ : ��ü�� ���� z��ǥ

* @return
* void

* @example
* var RadarMapCtrlHandle r_handle;
* r_handle = GetRadarMapCtrlHandle("RadarMapWnd.RadarMapCtrl"); //�ڵ��� �����´�
* r_handle.AddObject(100,"PartyMember", "Sohee", -93365, 238772, -3510); //(-93365,238772,-3510)�� WC�� �츮 ���� ��Ƽ����� ǥ���ϵ��� �߰��Ѵ�
* r_handle.DeleteObject(100, -100000, 238772, -3510); //��ü�� ��ġ�� �����Ѵ�
*/
native final function UpdateObject(int ID, int WorldX, int WorldY, int WorldZ);

/**
* �ڽ� �ֺ��� ������ ��û�Ѵ�. CPP�ܿ����� ��ü�ֺ��� ������ ���� �� ������ŭ EV_NotifyObject�� �߻���Ű�� ���ÿ� parameter�� type, ID, name, x, y, z������ �Ѱ��ش�.
* ���� ���Լ��� ������ ��û�һ� ���̴��� ǥ�������� �ʴ´�.
* ���� ���̴��� ǥ�ø� ���Ѵٸ� EV_NotifyObject�� ���� �ڵ鷯�� ����Ͽ� Addobject���� ����Ͽ� ó��������

* @param
* ObjectType : ��û�� ��ü�� Ÿ��(OBJ_TYPE_MONSTER : ���������� ���´�
* �������� : 1
* ��Ƽ������� : 2
* Ŭ�������� : 3
* ����̾����� : 4
* ���������� : 5
* �Ƶ������� : 6 

* DistanceLimitXY : �¿����
* DistanceLimitZ : ���Ϲ���

* @return
* void

* @example
* var RadarMapCtrlHandle r_handle;
* r_handle = GetRadarMapCtrlHandle("RadarMapWnd.RadarMapCtrl"); //�ڵ��� �����´�
* r_handle.RequestObjectAround(OBJ_TYPE_MONSTER, 100,100); //�����¿� 100���� ���� ���������� ��û�Ѵ�.
* //RadarMapWnd.uc ���� EV_NotifyObject�� ���� �ڵ鷯�� �����Ͽ� �̸� ���̴��� ǥ�����ش�
*/
native final function RequestObjectAround(int ObjectType, int DistanceLimitXY, int DistanceLimitZ);

/**
* ������ �����Ѵ�.

* @param
* newMag : ������ ����

* @return
* void

* @example
* var RadarMapCtrlHandle r_handle;
* r_handle = GetRadarMapCtrlHandle("RadarMapWnd.RadarMapCtrl"); //�ڵ��� �����´�
* r_handle.SetMagnification(1); // ������ 100���� ����
*/
native final function SetMagnification(float newMag);

/**
* Rotation ���θ� �����Ѵ�

* @param
* bEnable : true�� ���, false �� �Ұ�

* @return
* void

* @example
* var RadarMapCtrlHandle r_handle;
* r_handle = GetRadarMapCtrlHandle("RadarMapWnd.RadarMapCtrl"); //�ڵ��� �����´�
* r_handle.SetEnableRotation(false); // �����ʰ� �Ѵ�.
*/
native final function SetEnableRotation(bool bEnable);

/**
* ��Ʈ���� ������ ���θ� �����Ѵ�.

* @param
* bEnable : true�� ���, false �� �Ұ�

* @return
* void

* @example
* var RadarMapCtrlHandle r_handle;
* r_handle = GetRadarMapCtrlHandle("RadarMapWnd.RadarMapCtrl"); //�ڵ��� �����´�
* r_handle.SetMapInvisible(true); // �������ʰ� �Ѵ�.
*/
native final function SetMapInvisible(bool bInvisible);
defaultproperties
{
}
