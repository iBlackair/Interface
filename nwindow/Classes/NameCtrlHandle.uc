/**
*������Ʈ�ѿ� ���� �Լ��� ����
*/
class NameCtrlHandle extends WindowHandle
	native;
	
/**
* ǥ�õǴ� �̸��� �����Ѵ�

* @param
* Name : ������ �̸�
* Type : ��Ʈ���� Ÿ��
* Align : ��Ʈ���� ���Ļ���

* @return
* void

* @example
* var NameCtrlHandle NameCtrl;
* NameCtrl = GetNameCtrlHandle ("StatusWnd.UserName"); //�ڵ��� �����´�
* NameCtrl.SetName("Hello",NCT_Normal,TA_Center); //hello�� ǥ���Ѵ�. �븻��Ʈ��. ��� ����
* }

*enum ENameCtrlType
*{
*	NCT_Normal,
*	NCT_Item
*};

*enum ETextAlign
*{
*	TA_Undefined,
*	TA_Left, 
*	TA_Center,
*	TA_Right,
*	TA_MacroIcon,
*};
*/
native final function SetName(string Name,ENameCtrlType Type,ETextAlign Align);

/**
* ǥ�õǴ� �̸��� �����Ѵ�(����� �Բ�)

* @param
* Name : ������ �̸�
* Type : ��Ʈ���� Ÿ��
* Align : ��Ʈ���� ���Ļ���
* NameColor : ����

* @return
* void

* @example
* var NameCtrlHandle NameCtrl;
* var Color tcolor;
* tcolor.R = 255;
* tcolor.G = 0;
* tcolor.B = 0;
* tcolor.A = 255;
* NameCtrl = GetNameCtrlHandle ("StatusWnd.UserName"); //�ڵ��� �����´�
* NameCtrl.SetNameWithColor("Hello",NCT_Normal,TA_Center, tcolor); //hello�� ǥ���Ѵ�. �븻��Ʈ��. ��� ����,������
* }

*enum ENameCtrlType
*{
*	NCT_Normal,
*	NCT_Item
*};

*enum ETextAlign
*{
*	TA_Undefined,
*	TA_Left, 
*	TA_Center,
*	TA_Right,
*	TA_MacroIcon,
*};
*/
native final function SetNameWithColor(string Name,ENameCtrlType Type,ETextAlign Align,Color NameColor);

/**
* ��Ʈ�ѿ� ǥ�õǴ� �̸��� �����´�

* @param
* void

* @return
* string : �̸�

* @example
* var NameCtrlHandle NameCtrl;
* NameCtrl = GetNameCtrlHandle ("StatusWnd.UserName"); //�ڵ��� �����´�
* debug(NameCtrl.GetName()); //�̸��� ������ ����Ѵ�.
* }
*/
native final function string GetName();
defaultproperties
{
}
