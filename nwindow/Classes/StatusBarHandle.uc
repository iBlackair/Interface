/**
*���¹ٿ� ��Ʈ�ѿ� ���� �Լ��� ����
*/
class StatusBarHandle extends WindowHandle
	native;

/**
*�������ͽ����� ���� �����Ѵ�.
* @param
* CurrentValue : ������ ��
* MaxValue : �ִ밪

* @return
*void

* @example
*var StatusBarHandle s_handle;
*s_handle = GetStatusBarHandle( "StatusWnd.CPBar" ); //�ڵ��� �����´�
*s_handle.SetPoint(100,1000); // ��ü 100/1000 ���� ǥ�õȴ�
*/	
native final function SetPoint(int CurrentValue,int MaxValue);

/**
*�������ͽ����� ���� �ۼ�Ʈ���� ǥ���Ѵ�.
* @param
* CurrentValue : ������ ��
* MinValue : �ּҰ�
* MaxValue : �ִ밪

* @return
*void

* @example
*var StatusBarHandle s_handle;
*s_handle = GetStatusBarHandle( "StatusWnd.CPBar" ); //�ڵ��� �����´�.
*s_handle.SetPointPercent(100,1000,2000); // 90.00% ���ǥ�õȴ�
*/	
native final function SetPointPercent(INT64 CurrentValue,INT64 MinValue,INT64 MaxValue);


/**
*�������ͽ����� ���� ����ġ �ۼ�Ʈ���� ǥ���Ѵ�
* @param
* CurrentPercentRate : ����ġ percent rate

* @return
*void

* @example
*var StatusBarHandle s_handle;
*s_handle = GetStatusBarHandle( "StatusWnd.CPBar" ); //�ڵ��� �����´�.
*s_handle.SetPointExpPercentRate(30.0); // 30  �ۼ�Ʈ�� ǥ���Ѵ�.
*/
native final function SetPointExpPercentRate(float CurrentPercentRate); 

/**
*�������ͽ����� ���� ����(������������)ǥ���Ѵ�
* @param
* duration : �����Ǵ� �ð�
* ticks : �ѹ� �����ɶ� �ҿ�Ǵ� tick
* amount : ������

* @return
*void

* @example
*var StatusBarHandle s_handle;
*s_handle = GetStatusBarHandle( "StatusWnd.HPBar" ); //�ڵ��� �����´�.
*s_handle.SetRegenInfo(15,3,8); // 15�ʵ��� 8�� �������� 3tick ���� ��������. ������ �������� hp�� �����ϱ� ������ ������ ���������� �ʴ´�. 
*/
native final function SetRegenInfo(int duration,int ticks,float amount);
defaultproperties
{
}
