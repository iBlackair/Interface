/**
*�ؽ�����Ʈ�ѿ� ���� �Լ��� �����ϰ� �ִ�.
*/

class TextureHandle extends WindowHandle
	native;
/**
* �ؽ�����Ʈ�ѿ� �ؽ��ĸ� ������.
* @param
* a_TextureName : �ؽ����̸�

* @return
* void

* @example
*var TextureHandle	hTex; //�ؽ��� �ڵ� ����
*hTex = GetTextureHandle("RadarMapWnd.texZone"); //�ؽ�����Ʈ���� �ڵ��� �����´�
*hTex.SetTexture("L2UI_CT1.radarmap_df_region_gray"); //�ؽ��ĸ� ������.
*/
native final function SetTexture( String a_TextureName );

/**
* �ؽ�����Ʈ���� ������ǥ�� U,V ���� ���Ѵ�.
* @param
* a_U : U(����) ��
* a_V : V(����) ��

* @return
* void

* @example
*var TextureHandle	hTex; //�ؽ��� �ڵ� ����
*hTex = GetTextureHandle("RadarMapWnd.texZone"); //�ؽ�����Ʈ���� �ڵ��� �����´�
*hTex.SetUV(100,100); //UV ���� 100,100 ���� �Ѵ�.
*/
native final function SetUV( int a_U, int a_V );

/**
* �ؽ�����Ʈ���� ����� ���Ѵ�.
* @param
* a_UL : ���ΰ�
* a_VL : ���ΰ�

* @return
* void

* @example
*var TextureHandle	hTex; //�ؽ��� �ڵ� ����
*hTex = GetTextureHandle("RadarMapWnd.texZone"); //�ؽ�����Ʈ���� �ڵ��� �����´�
*hTex.SetTextureSize(100,100); //����� 100,100 ���� �Ѵ�.
*/
native final function SetTextureSize( int a_UL, int a_VL );

/**
* �ؽ�����Ʈ���� Ÿ���� ���Ѵ�.
* @param
* type : �ؽ�����Ʈ���� Ÿ��
*enum ETextureCtrlType
*{
*    TCT_Stretch             =0,
*    TCT_Normal              =1,
*    TCT_Tile                =2,
*    TCT_Draggable           =3,
*    TCT_Control             =4,
*    TCT_Mask                =5,
*    TCT_MAX                 =6,
*};
* @return
* void

* @example
*var TextureHandle	hTex; //�ؽ��� �ڵ� ����
*hTex = GetTextureHandle("RadarMapWnd.texZone"); //�ؽ�����Ʈ���� �ڵ��� �����´�
*hTex.SetTextureCtrlType(TCT_Stretch);
*/
native final function SetTextureCtrlType(ETextureCtrlType type);

/**
* 
* @param
* clanID : 

* @return
* void

* @example
*/
native final function SetTextureWithClanCrest(int clanID);

/**
* 
* @param
* objTexture : 

* @return
* void

* @example
*/
native final function SetTextureWithObject(texture objTexture);

/**
* �ؽ����� �̸��� �����´�.
* @param
* void

* @return
* string : �ؽ����� �̸�

* @example
*var TextureHandle	hTex; //�ؽ��� �ڵ� ����
*hTex = GetTextureHandle("RadarMapWnd.texZone"); //�ؽ�����Ʈ���� �ڵ��� �����´�
*hTex.SetTexture("L2UI_CT1.radarmap_df_region_gray"); //�ؽ��ĸ� ������.
*debug(hTex.GetTextureName()); // �ؽ����� �̸��� ������ ����Ѵ�
*/
native final function string GetTextureName();

/**
* �ؽ����� �ڵ� ȸ�� Ÿ���� ���Ѵ�.
* @param
* objTexture : ȸ��Ÿ�� 
*enum ETextureAutoRotateType
*{
*	ETART_None,
*	ETART_Camera,
*	ETART_Pawn
*};
* @return
* void

* @example
*var TextureHandle	hTex; //�ؽ��� �ڵ� ����
*hTex = GetTextureHandle("RadarMapWnd.texZone"); //�ؽ�����Ʈ���� �ڵ��� �����´�
*hTex.SetTexture("L2UI_CT1.radarmap_df_region_gray"); //�ؽ��ĸ� ������.
*hTex.SetAutoRotateType(ETART_Camera);
*/
native final function SetAutoRotateType(ETextureAutoRotateType Type);

/**
* �ؽ����� ȸ�������� ���Ѵ�.
* @param
* Dir : ����

* @return
* void

* @example
*var TextureHandle	hTex; //�ؽ��� �ڵ� ����
*hTex = GetTextureHandle("RadarMapWnd.texZone"); //�ؽ�����Ʈ���� �ڵ��� �����´�
*hTex.SetTexture("L2UI_CT1.radarmap_df_region_gray"); //�ؽ��ĸ� ������.
*hTex.SetAutoRotateType(ETART_Camera);
*hTex.SetAutoRotatingDirection(1); 
*/
native final function SetRotatingDirection(int Dir);

/**
* �ؽ����� Ư�� ��ǥ�� Į�� �����´�.
* @param
* a_U : U(����) ��
* a_V : V(����) ��

* @return
* Color : ����

* @example
*var TextureHandle	hTex; //�ؽ��� �ڵ� ����
*var Color TexColor;
*hTex = GetTextureHandle("RadarMapWnd.texZone"); //�ؽ�����Ʈ���� �ڵ��� �����´�
*hTex.SetTexture("L2UI_CT1.radarmap_df_region_gray"); //�ؽ��ĸ� ������.
*TexColor = hTex.GetColor(10,10); // 10,10 �� ������ �����´�.
*/
native final function Color GetColor(int a_U, int a_V);

/**
* �ؽ����� �⺻ RGB ���� ��ȭ��Ų��.
* @param
* a_ColorModift : RGB ��

* @return
* void

* @example
*var TextureHandle	hTex; //�ؽ��� �ڵ� ����
*var Color TexColor;
*hTex = GetTextureHandle("RadarMapWnd.texZone"); //�ؽ�����Ʈ���� �ڵ��� �����´�
*hTex.SetTexture("L2UI_CT1.radarmap_df_region_gray"); //�ؽ��ĸ� ������.
*TexColor = hTex.GetColor(10,10); // 10,10 �� ������ �����´�.
*hTex.SetColorModify(TexColor); //������ ������ ���������Ͽ� RGB���� ��ȭ��Ų��
*/
native final function SetColorModify(Color a_ColorModify);
defaultproperties
{
}
