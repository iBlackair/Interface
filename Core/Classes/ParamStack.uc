//=============================================================================
/// Locale: ParamStack class.
///============================================================================
/// ���Ѭܬ֬� ��֬�֬�Ѭܬ�ӬѬ� �� ��֬�֬�ѬҬ��Ѭ� BITHACK ������ѬӬڬ� BITHACK =)
//=============================================================================
class ParamStack extends object
	native
	noexport;
	
var int stack; //�����δ� l2paramstack �����͸� ��������� 4byte ����� ���߱� ���� int��...
	
native function string GetString();
native function int	GetInt();
native function float GetFloat();

//2006.6 ttmayrin
native function PushInt(int item);
native function PushString(string item);
defaultproperties
{
}
