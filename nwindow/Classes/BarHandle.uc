/**
*����Ʈ��(statusbar��Ʈ�ѿ� ���� ����Ʈ�� ��Ʈ��)�� ���� �Լ��� ����
*/
class BarHandle extends WindowHandle
	native;
/**
*���� ���� �����Ѵ�.
* @param
* a_CurValue : ������ ��
* a_MaxValue : �ִ밪

* @return
*void

* @example
*var BarHandle b_handle;
*b_handle = GetBarHandle( "RecipeBuyManufactureWnd.barMp" ); //�ڵ��� �����´�
*b_handle.SetPoint(100,1000); // ��ü 100/1000 ���� ǥ�õȴ�
*/	
native final function SetValue( int a_MaxValue, int a_CurValue );

/**
*���� ���� �����´�
* @param
* a_CurValue : ������ ���� ����� ����
* a_MaxValue : �ִ밪�� ����� ����

* @return
*void

* @example
*var BarHandle b_handle;
*var int MaxValue;
*var int CurValue;
*b_handle = GetBarHandle( "RecipeBuyManufactureWnd.barMp" ); //�ڵ��� �����´�
*b_handle.GetValue(MaxValue, CurValue); //���� �����´�
*/
native final function GetValue( out int a_MaxValue, out int a_CurValue );

/**
*�ٸ� �ʱ�ȭ �Ѵ�
* @param
* void

* @return
*void

* @example
*var BarHandle b_handle;
*b_handle = GetBarHandle( "RecipeBuyManufactureWnd.barMp" ); //�ڵ��� �����´�
*b_handle.Clear(); //�ʱ�ȭ�Ѵ�
*/
native final function Clear();


/**
*�ٸ� �ؽ��ĸ� �����Ѵ�.
* @param
* int : TextureIdx : �ؽ�������  0:ForeLeft 1:ForeTexture 2:ForeRightTexture 3:BackLeftTexture 4:BackTexture 5:BackRightTexture
* int : TexName : �ؽ����̸�

* @return
*void

* @example
*/
native final function SetTexture(int TextureIdx, string TexName);
defaultproperties
{
}
