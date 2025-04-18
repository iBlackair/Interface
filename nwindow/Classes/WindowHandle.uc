/**
*�����쿡���� �Լ��� �����Ѵ�(�������� ��ǥ�� ���� �͵��� ���ֳ����µ� �����Ұ��� ��ǥ�谡 ���� �����ϴ� �Ǽ������ �ƴ϶� ȭ����ǥ�� ��� ���̴�. �� ���»�� �� (0,0) �̰� ���������� ������, �Ʒ����̴�)
*/

class WindowHandle extends UIEventManager
	native;

var Object m_pTargetWnd;
var string m_WindowNameWithFullPath;

/**
*�������� Ÿ��Ʋ�� �����Ѵ�.

* @param
*a_Title : ������ Ÿ��Ʋ

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetWindowTitle("Sohee JJang!!"); // �������� Ÿ��Ʋ�� �����Ѵ�.
*Hwnd_Party.ShowWindow();//�����츦 �����ش�
*/
native final function SetWindowTitle( String a_Title );

/**
*Ÿ��Ʋ�� ��ġ�� �����Ѵ�.

* @param
*OffsetX : X��ǥ(����) 
*OffsetY : Y��ǥ(����) 

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetTitlePosOffset(10,10); //Ÿ��Ʋ�� ��ġ�� �����Ѵ�.
*Hwnd_Party.ShowWindow();//�����츦 �����ش�
*/
native final function SetTitlePosOffset(int OffsetX, int OffsetY);

/**
*�����츦 �����ش�(�ݴ�:HideWindow())

* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.ShowWindow();//�����츦 �����ش�
*/
native final function ShowWindow();

/**
*�����츦 �����(�ݴ�:ShowWindow())

* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.HideWindow();//�����츦 �����ش�.
*/
native final function HideWindow();

/**
*�������� Show ���θ� �����Ѵ�.

* @param
*void

* @return
*bool : Show�����̸� true, Hide�����̸� false

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*if(Hwnd_Party.IsShowWindow()) Hwnd_Party.HideWindow();//�����찡 �������������� �����츦 �����ش�
*else Hwnd_Party.ShowWindow(); //�ݴ�� ������ �ִٸ� �����ش�. ������ Toggle ����� �����ȴ�.
*/
native final function bool IsShowWindow();

/**
*�����찡 �ּ�ȭ ���������� �Ǵ��Ѵ�.

* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*if(Hwnd_Party.IsMinimizedWindow()) debug("minimized"); //�����찡 �ּ�ȭ ���¶�� ��µȴ�
*/
native final function bool IsMinimizedWindow();

/**
*�������� �̸��� �����Ѵ�.

* @param
*void

* @return
*string : �������� �̸�

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var string WndName;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*WndName = Hwnd_Party.GetWindowName();//�������� �̸��� �����´�
*debug(WndName); //"PartyMatchWnd" �� ��µȴ�.
*/
native final function String GetWindowName();

/**
*�θ��������� �̸��� �����Ѵ�.

* @param
*void

* @return
*string : �θ� �������� �̸�

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var string WndName;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*WndName = Hwnd_Party.GetParentWindowName();//�θ� �������� �̸��� �����´�
*debug(WndName); //"Console"�� ��µȴ�.
*/
native final function String GetParentWindowName();

/**
*�θ� �����츦 �����Ѵ�.

* @param
*a_hNeweParentWnd : ���ο� �θ�������

* @return
*bool : ������ true, ���н� false

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var WindowHandle Hwnd_Party_Parent; //�θ������� �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party_Parent = GetWindowHandle("ActionWnd"); // ActionWnd.uc�� ������� �������� �ڵ��� �����´�.
*Hwnd_Party.ChangeParentWindow(Hwnd_Party_Parent); //partyMatchwnd�� Parent�� console���� ActionWnd �� �����Ѵ�.
*/
native final function bool ChangeParentWindow( WindowHandle a_hNewParentWnd );

/**
*�θ� �������� �ڵ��� �����Ѵ�.

* @param
*void

* @return
*WindowHandle : �θ��� ������ �ڵ�

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var WindowHandle Hwnd_Party_Parent; //�θ������� �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party_Parent = Hwnd_Party.GetParentWindowHandle(); // PartyMatchWnd�� �θ��ڵ�(console)�� �����´�.
*/
native final function WindowHandle GetParentWindowHandle();

/**
*�ڽ� �������� �迭�� ���´�.

* @param
*array<WindowHandle> : �ڽĵ��� ��� ������ �ڵ� �迭.

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var array<WindowHandle> Hwnd_Party_Childs; //�������ڵ� �迭 ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.GetChildWindowList(Hwnd_Party_Childs); //Hwnd_Party_Childs �� �ڽ� ��������� ����.
*/
native final function GetChildWindowList( array<WindowHandle> a_ChildList );

/**
*�ڽ��� �Ķ���� �ڵ��������� �ڽ������� ���� ���θ� �����Ѵ�.

* @param
*WindowHandle a_hParentWnd : �θ�� �ǽɵǴ� ������ �ڵ�

* @return
*bool : �ڽ��� �´ٸ� true, �ƴϸ� false

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var WindowHandle Hwnd_Party_Parent; //�θ������� �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party_Parent = GetWindowHandle("ActionWnd"); // ActionWnd.uc�� ������� �������� �ڵ��� �����´�.
*if(Hwnd_Party.IsChildOf(Hwnd_Party_Parent)) debug("yes"); //��µ��� �ʴ´�.
*else debug("no"); //��µȴ�.
*/
native final function bool IsChildOf( WindowHandle a_hParentWnd );

/**
*�ֻ��� �������� ������ �ڵ��� �����Ѵ�.

* @param
*void

* @return
*WindowHandle : �ֻ��� �������� ������ �ڵ�

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var WindowHandle Hwnd_Party_Top;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party_Top = Hwnd_Party.GetTopFrameWnd(); // PartyMatchWnd�������� �ֻ��� ������ �����츦 �����´�.
*debug(string(Hwnd_Party_Top)); //"Transient.WindowHandle911" �� ��µǾ���. ������ ���� �˾ƺ���
*/
native final function WindowHandle GetTopFrameWnd();

/**
*�������� ���İ��� �����´�.

* @param
*void

* @return
*int : �������� ���İ�

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var int Alpha; // ���İ��� ���� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Alpha = Hwnd_Party.GetAlpha(); // ���İ��� �����´�.
*debug(string(Alpha)); //255(������ ����) �� ��µǾ���.
*/
native final function int GetAlpha();

/**
*�������� ���İ��� �����Ѵ�.

* @param
*a_Alpha : ���İ�
*a_Seconds(optional) : ���ʾȿ� ���Ұ��ΰ�

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetAlpha(0); // ���İ��� 0���� �ٲ۴�.
*Hwnd_Party.SetAlpha(255,10); // ���İ��� 255�� 10�ʸ��� �ٲ۴�.
*/
native final function SetAlpha( int a_Alpha, optional float a_Seconds );

/**
*�������� UC ��ũ��Ʈ�� �����´�(UC�����̶�⺸�ٴ� ���� ���̳ʸ����� �׳� UC��� �����ϸ� �ɵ��ϴ�)
*���� �������� UC ��ũ��Ʈ�� XML���Ͽ� ���ǵǾ��ִ�. 

* @param
*void

* @return
*UIScript : �������� UC ��ũ��Ʈ

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var PartyMatchWnd Hwnd_Party_Script; //PartymatchWnd ��ũ��Ʈ�� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party_Script = PartyMatchWnd(Hwnd_Party.GetScript()); //��ũ��Ʈ�� �����´�. ĳ������ �ʿ��ϴ�.
*Hwnd_Party_Script.HandlePartyToggle(); // PartymatchWnd �� ����Լ��� ����� �����ϴ�.
*/
native final function UIScript GetScript();

/**
*�������� UC ��ũ��Ʈ�� �̸��� �����´�. 

* @param
*void

* @return
*string : UC ��ũ��Ʈ�� �̸�

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var string ScriptName;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*ScriptName = Hwnd_Party.GetScriptName(); //��ũ��Ʈ�� �̸��� �����´�.
*/
native final function String GetScriptName();

//Style

/**
*�����찡 Virtual ��Ÿ��(��ǲ �̺�Ʈ�� dispatch �Ҽ�����, �׷��� child�� ����)���� �˾ƺ���.

* @param
*void

* @return
*bool

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*if(Hwnd_Party.IsVirtual()) debug("virtual style"); //���߾� ��Ÿ���̸� ���
*else debug("Not Virtual style"); //���߾� ��Ÿ���� �ƴϸ� ���
*/
native final function bool IsVirtual();

/**
*�����찡 ������ �ֻ����� �ִ��� �˾ƺ���. 

* @param
*void

* @return
*bool

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*if(Hwnd_Party.IsAlwaysOnTop()) debug("Top");
*else debug("No Top");
*/
native final function bool IsAlwaysOnTop();

/**
*�����찡 ������ ���� �ڿ� �ִ��� �˾ƺ���. 

* @param
*void

* @return
*bool

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*if(Hwnd_Party.IsAlwaysOnBack()) debug("Back");
*else debug("No Back");
*/
native final function bool IsAlwaysOnBack();

/**
*�������� ��Ʈ ������ ���Ѵ�. 

* @param
*a_FontColor : ����

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var color TextColor;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*TextColor= GetNumericColor("83,473"); 
*Hwnd_Party.SetFontColor( TextColor ); //���� �����Ѵ�.
*/
native final function SetFontColor( color a_FontColor );

/**
*�������� ���İ��� ������ �ִ�� �Ѵ�. Ȥ�� �����Ѵ�.

* @param
*a_AlwaysFullAlpha : true�� ���İ� �ִ�. false �� ����

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetAlwaysFullAlpha(true);
*/
native final function SetAlwaysFullAlpha(bool a_AlwaysFullAlpha);

/**
*�����츦 ���������(������ Ȱ��ȭ�� �θ���������� �Է��� ���´�)�� �ϰų� �����Ѵ�.

* @param
*a_Modal : true�� ����. false �� ����

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetModal(true);// ��������� ������� �Ѵ�.
*/
native final function SetModal(bool a_Modal);

//Size&Position

/**
*�������� ����� Rect���·� �����Ѵ�.

* @param
*void

* @return
*Rect : �������� ����� ���� Rect

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Rect WindowRect;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*WindowRect = Hwnd_Party.GetRect();
*/
native final function Rect GetRect();

/**
*�������� ����� ������Ų��.

* @param
*a_DeltaWidth : ���������� 
*a_DeltaHeight : ����������

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*HWnd_Party.AddWindowSize(10,10); // 10,10 ��ŭ ������ ����� �����Ѵ�.
*/
native final function AddWindowSize( int a_DeltaWidth, int a_DeltaHeight );

/**
*�������� ����� �����Ѵ�.

* @param
*a_Width : ���̰�
*a_Height : ���̰�

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*HWnd_Party.SetWindowSize(10,10); // 10,10ũ��� �����츦 �����Ѵ�.
*/
native final function SetWindowSize( int a_Width, int a_Height );

/**
*�������� ����� �˾Ƴ���.

* @param
*a_Width : ���̰��� ����� ����
*a_Height : ���̰��� ����� ����

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var int w;
*var int h;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*HWnd_Party.GetWindowSize(w,h); // �������� ����� �˾Ƴ���.
*/
native final function GetWindowSize( out int a_Width, out int a_Height );

/**
*�������� ����� ��������� �����Ѵ�. (�� �� �����δ� SetWindowSizeRel43 �� �����̴�����)

* @param
*fWidthRate : ���� ����
*fHeightRate : ���� ����
*nOffsetWidth : ??? �ƽôº� ������
*nOffsetHeight : ??? �ƽôº� ������

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*HWnd_Party.SetWindowSizeRel(0.5,0.5,0,0); //�������� �����ϱ��??? �ƽôº� ������
*/
native final function SetWindowSizeRel( float fWidthRate, float fHeightRate, int nOffsetWidth, int nOffsetHeight );

/**
*�������� ������� ũ������� �˾Ƴ���.(�� ��)

* @param
*fWidthRate : ���� ����
*fHeightRate : ���� ����
*nOffsetWidth : ??? �ƽôº� ������
*nOffsetHeight : ??? �ƽôº� ������

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var float fw;
*var float fh;
*var int w;
*var int h;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*HWnd_Party.GetWindowSizeRel(fw,fh,w,h); // ������ ���ȵ� �մϴ�. 0.0, 0.0, 0, 0 �� ���������� 
*/
native final function GetWindowSizeRel( out float fWidthRate, out float fHeightRate, out int nOffsetWidth, out int nOffsetHeight );

/**
*�������� ����� ��������� �����Ѵ�. (�� ��)

* @param
*fWidthRate : ���� ����
*fHeightRate : ���� ����
*nOffsetWidth : ??? �ƽôº� ������
*nOffsetHeight : ??? �ƽôº� ������

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*HWnd_Party.SetWindowSizeRel43(0.5,0.5,0,0); // ������ �ٵ������� ������ ���� �ʴ�����
*/
native final function SetWindowSizeRel43( float fWidthRate, float fHeightRate, int nOffsetWidth, int nOffsetHeight);	//solasys

/**
*�������� ����� ����������� �Ǵ��Ѵ�.

* @param
*void

* @return
*bool : ������̸� true �ƴϸ� false

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var bool IsRelative;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*IsRelative = Hwnd_Party.IsRelativeSize(); // ���ũ������ �˾Ƴ���
*/
native final function bool IsRelativeSize();

/**
*�����츦 ��ȭ�� ��ŭ �̵���Ų��.

* @param
*a_nDeltaX : X���� ��ȭ��
*a_nDeltaY : Y���� ��ȭ��
*a_Seconds(optional) : �̵��� �ð�

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.Move(10,10); // ���������� 10 �Ʒ��� 10 ��ŭ �̵��Ѵ�.
*Hwnd_Party.Move(10,10, 10); // ���������� 10 �Ʒ��� 10 ��ŭ 10�ʰ� �̵��Ѵ�.
*/
native final function Move( int a_nDeltaX, int a_nDeltaY, optional float a_Seconds );

/**
*�����츦 ������ ��ǥ�� �̵���Ų��.

* @param
*a_nDeltaX : X��ǥ
*a_nDeltaY : Y��ǥ
*a_Seconds(optional) : �̵��� �ð�

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.MoveTo(10,10); // (10,10) �� ��ġ�� �����츦 �̵��Ѵ�.
*/
native final function MoveTo( int a_nX, int a_nY );

/**
*�����츦 ������ġ���� �̵���Ų��.

* @param
*a_nX : X��ǥ ��ȭ��
*a_nY : Y��ǥ ��ȭ��

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.MoveTo(10,10); // ������ġ����(10,10)��ŭ �����츦 �̵��Ѵ�.
*/
native final function MoveEx( int a_nX, int a_nY );

/**
*�����츦 ������ġ���� �־��� �ð����� �̵���Ų��.

* @param
*a_nX : X��ǥ ��ȭ��
*a_nY : Y��ǥ ��ȭ��
*a_Seconds : �̵��� �ð�

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.MoveEx(10,10,10); // ������ġ����(10,10)��ŭ �����츦 10�ʰ� �̵��Ѵ�.
*/
native final function MoveExWithTime( int a_nX, int a_nY, float a_Seconds );

/**
*�����츦 ������ ����(8����)���� �̵���Ų��(�Լ��̸��� ��ġ ���� ������ �ƴϴ�. ���Լ��� �������� ȣ���ϸ� ���� ���� ȿ���� ����)
*�ٿ���� ������ ��� ��� ���ٺ��� �־������� �����츦 ���� �ִ�.(�߰��ϸ� ������)

* @param
*a_nRange : ������ �Ÿ�
*a_nSet : 0�� �־�� �����ϰ� �����δ�. �ٸ����� ������ ������ ���� �����δ�(�� �ִ��� �߸𸣰�..)
*a_Seconds(optional) : ������ �ð�

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.MoveShake(10,0,0.1); // 10��ŭ �����츦 0.1�ʸ��� �����ϰ� �̵���Ų��.
*/
native final function MoveShake( int a_nRange, int a_nSet, optional float a_Seconds );	//solasys

// Tick
/**
*�����찡 Tick�� �����ϰ� �����.

* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.EnableTick(); // Tick�� �����Ѵ�. ���� PatcyMatchWnd.uc �� Ontick�Լ��� �����ϸ� Tick���� ����ȴ�.
*/
native final function EnableTick();

/**
*�����찡 Tick�� �������� �ʰ� �����.

* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.EnableTick(); // Tick�� �������� �ʴ´�. ���� PatcyMatchWnd.uc �� Ontick�Լ��� �����ص� ���õȴ�.
*/
native final function DisableTick();

//Anchor

/**
*�����쿡 Anchor�� �����Ѵ�.(�� ������ �پ�ٴϴ� �����츦 �����Ѵ�)
*���������� �� ������ ��� Show �� ���¿����� ������ �ȴٴ� ���̴�. ���� ���� show�� ���ְ� anchor�� ��������

* @param
*AnchorWindowName : �ڽ��� ����ٴ� �������� �̸�
*RelativePoint : �ڽ��� ����ٴ� �������� ���� ����Ʈ
*AnchorPoint : �ڽ��� Anchor(����)����Ʈ
*offsetX : RelativePoint ���� Anchor����Ʈ���� X���� offset
*offsetY : RelativePoint ���� Anchor����Ʈ���� Y���� offset

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var WindowHandle Hwnd_Party2; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party2 = GetWindowHandle("InventoryWnd"); // Inventory.uc�� ������� �������� �ڵ��� �����´�.
*Hwnd_Party.ShowWindow();
*Hwnd_Party2.ShowWindow();
*Hwnd_Party.SetAnchor("InventoryWnd", "TopLeft", "BottomRight", 100,0); //��Ƽ�������� ������ �Ʒ��� �κ��������� �������� ������ �Ǿ� �ٴ´�. �κ��������� ���������� X�������� 100��ŭ �� ���� �ٴ´�
*/
native final function SetAnchor( string AnchorWindowName, string RelativePoint, string AnchorPoint, int offsetX, int offsetY );

/**
*�����쿡 Anchor�� �����Ѵ�.

* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var WindowHandle Hwnd_Party2; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party2 = GetWindowHandle("InventoryWnd"); // Inventory.uc�� ������� �������� �ڵ��� �����´�.
*Hwnd_Party.ShowWindow();
*Hwnd_Party2.ShowWindow();
*Hwnd_Party.SetAnchor("InventoryWnd", "TopLeft", "BottomRight", 100,0); //��Ƽ�������� ������ �Ʒ��� �κ��������� �������� ������ �Ǿ� �ٴ´�. �κ��������� ���������� X�������� 100��ŭ �� ���� �ٴ´�
*Hwnd_Party.ClearAnchor(); //��Ŀ�� �����Ǿ���
*/
native final function ClearAnchor();

/**
*�����쿡 Anchor�� �ִ��� ���θ� �����Ѵ�.

* @param
*void

* @return
*bool : Anchor�� ������ true ������ false

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var WindowHandle Hwnd_Party2; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party2 = GetWindowHandle("InventoryWnd"); // Inventory.uc�� ������� �������� �ڵ��� �����´�.
*Hwnd_Party.ShowWindow();
*Hwnd_Party2.ShowWindow();
*Hwnd_Party.SetAnchor("InventoryWnd", "TopLeft", "BottomRight", 100,0); //��Ƽ�������� ������ �Ʒ��� �κ��������� �������� ������ �Ǿ� �ٴ´�. �κ��������� ���������� X�������� 100��ŭ �� ���� �ٴ´�
*debug(string(Hwnd_Party.IsAnchored())); // PartyMatchWnd�� ��Ŀ�� �����Ƿ� true �� ��µȴ�
*debug(string(Hwnd_Party2.IsAnchored())); // InventoryWnd�� ��Ŀ�� ���Ѱ� ���̹Ƿ� false�� ��µȴ�.
*/
native final function bool IsAnchored();

//Draggable

/**
*�����찡 �巡�� �������� �˾ƺ���.

* @param
*void

* @return
*bool : �巡�� �����ϸ� true �ƴϸ� false

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var bool draggable;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*draggable = Hwnd_Party.IsDraggable();
*/
native final function bool IsDraggable();

/**
*�����찡 �巡�� �����ϵ���(Ȥ�� �Ұ����ϵ���)�Ѵ� (������ �ȵȵ��ϴ�)

* @param
*a_Draggable : true�� �巡�� ���� false�� �Ұ���

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetDraggable(true); //�巡�� ����
*Hwnd_Party.SetDraggable(false); //�巡�� �Ұ���
*/
native final function SetDraggable( bool a_Draggable );

// Style
/**
*�����찡 stuck(�ٸ� ������ �翡 �޶�ٴ°�)�� �����ϵ���(Ȥ�� �Ұ����ϵ���)�Ѵ� 
*stuckable �� �����쳢���� �翡 ���� �޶�ٴ´�

* @param
*a_Stuckable : true�� stuck ���� false�� �Ұ���

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetStuckable(true); //Stuck ����
*Hwnd_Party.SetStuckable(false); //Stuck �Ұ���
*/
native final function SetStuckable(bool a_Stuckable);

//VirtualDrag, ttmayrin
/**
*�����찡 VirtualDrag(VirtualBox�� ǥ���ϸ鼭, �����츦 Drag&Drop��ų �� �ִ�.)������ �����Ѵ�.
*������ �Ǿ����� �𸣰ڴ�. window�� style�� NWS_VIRTUALDRAG�� �ڵ忡�� ������ �ʾҴ�.
* @param
*void 

* @return
*bool : true�� VirtualDrag ���� false�� �Ұ���

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var VDrag;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*VDrag = Hwnd_Party.IsVirtualDrag();
*/
native final function bool IsVirtualDrag();

/**
*�����찡 VirtualDrag(VirtualBox�� ǥ���ϸ鼭, �����츦 Drag&Drop��ų �� �ִ�.)�ϰų� ���ϵ��� �����Ѵ�.
*������ �Ǿ����� �𸣰ڴ�. window�� style�� NWS_VIRTUALDRAG�� �ڵ忡�� ������ �ʾҴ�.
* @param
*a_bFlag : true�� ���� false�� ����

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetVirtualDrag(true); // virtualdraggable ����
*Hwnd_Party.SetVirtualDrag(false); // virtualdraggable ����
*/
native final function SetVirtualDrag( bool a_bFlag );

/**
*�����찡 �巡�׿��� �ɶ�(�����쿡 �巡�� �Ǿ� ���ö�)�� �ؽ��ĸ� �����Ѵ�.
* @param
*a_TextureName : �ؽ��� �̸�

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetDragOverTexture( "L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight" ); //�ؽ��ĸ� �����Ѵ�
*/
native final function SetDragOverTexture( string a_TextureName );

//Enable&Disable

/**
*�����츦 Enable���·� �Ѵ�. 
* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.EnableWindow();
*/

native final function EnableWindow();

/**
*�����츦 Disable���·� �Ѵ�.
* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.DisableWindow();
*/
native final function DisableWindow();

/**
*�����츦 Enable���¸� �����Ѵ�.
* @param
*void

* @return
*bool : Enable �̸� true Disable �̸� false

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*if (Hwnd_Party.IsEnableWindow()) debug("Enabled window"); //Enable ���¸� �Ǵ��� ����Ѵ�.
*else debug("Disabled window");
*/
native final function bool IsEnableWindow();

//Focus
/**
*�����쿡 ��Ŀ���� �����.(Ȱ��ȭ, �Է´�� ���°� �ȴ�)
* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.ShowWindow();
*Hwnd_Party.SetFocus(); //��Ŀ���� �����.
*/
native final function SetFocus();

/**
*�������� ��Ŀ�� ���θ� �����Ѵ�.
* @param
*void

* @return
*bool : ��Ŀ�̵Ǿ������� true �ƴϸ� false

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.ShowWindow();
*Hwnd_Party.SetFocus(); //��Ŀ���� �����.
*if(Hwnd_Party.IsFoucus()) debug("Focused");
*else debug("Defocused");
*/
native final function bool IsFocused();

/**
*�������� ��Ŀ���� �����Ѵ�.
* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.ShowWindow();
*Hwnd_Party.SetFocus(); //��Ŀ���� �����.
*Hwnd_Party.ReleaseFocus(); //��Ŀ���� �����.
*/
native final function ReleaseFocus();

//Timer

/**
*�����쿡 Ÿ�̸Ӹ� �����Ѵ�.
* @param
*a_TimerID : Ÿ�̸��� ���̵�
*a_DelayMiliseconds : ������ ������ (1/1000 ��)

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetTimer(1,1000); //ID=1, ������=1�� �� Ÿ�̸Ӹ� �����Ѵ�.

*function OnTimer(int TimerID) //OnTiemr �Լ����� Ÿ�̸Ӹ� ����ش�.
*{
*	if(TimerID == 1) //������ ID�� 1�̾����Ƿ�
*	{
		debug("Tiemr 1 has expired"); //���ϴ� �ൿ�� ���Ѵ�
*	}
*}
*/
native final function SetTimer( int a_TimerID, int a_DelayMiliseconds );

/**
*�����쿡 Ÿ�̸Ӹ� �����Ѵ�.
* @param
*a_TimerID : Ÿ�̸��� ���̵�

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetTimer(1,1000); //ID=1, ������=1�� �� Ÿ�̸Ӹ� �����Ѵ�.

*function OnTimer(int TimerID) //OnTiemr �Լ����� Ÿ�̸Ӹ� ����ش�.
*{
*	if(TimerID == 1) //������ ID�� 1�̾����Ƿ�
*	{
		debug("Tiemr 1 has expired"); //���ϴ� �ൿ�� ���Ѵ�
		Hwnd_Party.KillTimer(1); // Ÿ�̸Ӹ� �����Ѵ�. ���� 1�� Ÿ�̸Ӵ� 1ȸ�� �����ϰ� �����ȴ�
*	}
*}
*/
native final function KillTimer( int a_TimerID );

/**
*�ּ�ȭ�� ������ �������� �����̰� ���ش�.
* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetTimer(1,1000); //ID=1, ������=1�� �� Ÿ�̸Ӹ� �����Ѵ�.

*function OnTimer(int TimerID) //OnTiemr �Լ����� Ÿ�̸Ӹ� ����ش�.
*{
*	if(TimerID == 1) //������ ID�� 1�̾����Ƿ�
*	{
		Hwnd_Party.NotifyAlarm(); // �ּ�ȭ �Ǿ��ִٸ� �����̰� �Ѵ�.
*	}
*}
*/
native final function NotifyAlarm();

//Tooltip

/**
*������ ������ �ؽ�Ʈ�� �����Ѵ�.
* @param
*Text : �ؽ�Ʈ

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetToolTipText("This is PartymatchWnd");
*/
native final function SetTooltipText( string Text );

/**
*������ ������ �ؽ�Ʈ�� �����Ѵ�.
* @param
*void

* @return
*string : �������� ���� �ؽ�Ʈ

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var string ToolTipTxt;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetToolTipText("This is PartymatchWnd");
*ToolTipTxt = Hwnd_party.GetToolTipText();
*/
native final function string GetTooltipText();

/**
*������ ������ Ÿ���� ���Ѵ�.
* @param
*ToolTipType : ������ Ÿ��

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetToolTipType("PartyMatchWnd");
*/
native final function SetTooltipType( string TooltipType );

/**
*������ ������ Ŀ����Ÿ���� �����Ѵ�.
* @param
*Info : ������ Ŀ����Ÿ��

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var string ToolTipTxt;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetTooltipCustomType(MakeTooltipSimpleText("")); //Ŀ���� Ÿ���� �����ؽ�Ʈ�� �����Ѵ�.
*/
native final function SetTooltipCustomType( CustomTooltip Info );

/**
*������ ������ Ŀ����Ÿ���� ���´�.
* @param
*Info : Ŀ����Ÿ�� ������ ����

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*var CustomToolTip info;
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetTooltipCustomType(MakeTooltipSimpleText(""));//Ŀ���� Ÿ���� �����ؽ�Ʈ�� �����Ѵ�.
*Hwnd_Party.GetToolTipCustomType(info);//�����ؽ�Ʈ Ÿ���� info�� ���´�
*/
native final function GetTooltipCustomType( out CustomTooltip Info );

native final function ClearTooltip();
native final function ClearAllChildShortcutItemTooltip();
//Frame

/**
*������ �������� ũ�⸦ �����Ѵ�.
* @param
*nWindth : ����
*nHeight : ����

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd"); // PartyMatchWnd �������� �ڵ��� �����´�.
*Hwnd_Party.SetFrameSize(100,100); //������ ����� �����Ͽ���
*/
native final function SetFrameSize(int nWidth, int nHeight);
native final function SetResizeFrameSize(int nWidth, int nHeight);

//Scroll

/**
*������ ��ũ�ѹ��� ��ġ�� �������ش�
* @param
*X : ��ũ�ѹ���Ʈ�� ��ġ�� x��ǥ
*Y : ��ũ�ѹ���Ʈ�� ��ġ�� y��ǥ
*HeightOffset : ��ũ�ѳ��� ��ũ���� �����ϴ� ũ�⸦ �ǹ��Ѵ�. 0�����ϸ� ��ũ���� ũ�⸦ �������� �ʴ´�.

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("InventoryWnd.InventoryItem");
*Hwnd_Party.SetScrollBarPosition(0,50,0);//�κ��丮�� �����۽�ũ�ѹ��� ��ġ�� �����غ��Ҵ�. ���������� Ȯ���� �����ִ�
*/
native function SetScrollBarPosition(int X, int Y, int HeightOffset);

/**
*������ ��ũ�ѹٳ��� ��ũ���� ��ġ�� �������ش�
* @param
*pos : ��ũ���� ��ġ


* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("InventoryWnd.InventoryItem");
*Hwnd_Party.SetScrollPosition(0);//�κ��丮�� ��ũ�ѹٳ��� ��ũ���� ��ġ�� �ʱ�ȭ �Ͽ���.
*/
native final function SetScrollPosition(int pos);

/**
*������ ��ũ�ѹٳ��� ��ũ���� ũ�⸦ �������ش�
* @param
*Height : ũ��


* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("InventoryWnd.InventoryItem");
*Hwnd_Party.SetScrollHeight(1000);//�κ��丮�� ��ũ�ѹٳ��� ��ũ���� ũ�⸦ �����Ͽ���.
*/
native final function SetScrollHeight(int Height);

/**
*�θ� �������� �ڽ�������� ������ �����ʵ��� �Ѵ�.ex)Split�� ê�����츦 �������� �Ҷ� �ȵǰ���
* @param
*bFlag : true�� ���� false�� ����


* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd");
*Hwnd_Party.SetSettledWnd(true);
*/
native final function SetSettledWnd( bool bFlag );

/**
*�����츦 ȸ����Ų��? (������ �߸����. �����ϸ� ����Ÿ�� ������ �߻�)
* @param
*bWithCapture(optional) : 
*RotationTime(optional) :
*direction(optional) :
*BeginAlpha(optional) :
*EndAlpha(optional) :
*bCW(optional) :
*RotationConstant(optional) :


* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd");
*Hwnd_Party.Rotate(); //�����߻�
*/
native final function Rotate(optional bool bWithCapture, optional INT RotationTime, optional vector direction, optional INT BeginAlpha, optional INT EndAlpha, optional bool bCW, optional float RotationConstant);

/**
*�����츦 ȸ���� ������Ų�� (���� �κ��̾���)
* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd");
*Hwnd_Party.ClearRotation(); //ȸ���� ������Ų��.
*/
native final function ClearRotation();

/**
*InitRotation���̶�� true �ƴϸ� false (������ ����)
* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd");
*Hwnd_Party.IsFront(); //������ �������� m_bFront����� �����Ѵ�.
*/

native final function IsFront();
/**
*�����츦 ȸ����ų�� ������ ��Ű�� �ʴ´�. ¥�� ����. �ֱ׷��� �˾ƺ� �ʿ䰡 �ִ�.(������ ����)
* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd");
*Hwnd_Party.InitRotation();
*/
native final function InitRotation();

// For UIEditor

/**
*�����츦 ȸ����ų�� ������ ��Ű�� �ʴ´�. ¥�� ����. �ֱ׷��� �˾ƺ� �ʿ䰡 �ִ�.(������ ����)
* @param
*void

* @return
*void

* @example
*var WindowHandle Hwnd_Party; //������ �ڵ� ����
*Hwnd_Party = GetWindowHandle("PartyMatchWnd");
*Hwnd_Party.InitRotation();
*/
native final function SetEditable( bool bEnable );

native final function WindowHandle AddChildWnd( EXMLControlType ChildType );
native final function String GetClassName();
native final function DeleteChildWnd( string ChildName );
native final function SetBackTexture( string TextureName );
native final function SetScript( string ScriptName );
native final function bool IsControlContainer();
native final function EXMLControlType GetControlType();
native final function WindowHandle LoadXMLWindow( string FilePathName );
native final function bool SaveXMLWindow( string FilePathName );
native final function GetXMLDocumentInfo( out string Comment, out string NameSpace, out string XSI, out string SchemaLocation );
native final function SetXMLDocumentInfo( string Comment, string NameSpace, string XSI, string SchemaLocation );
native final function ConvertToEditable();
native final function bool MakeBaseUC( string UCName, string FilePathName );
native final function ChangeControlOrder( EControlOrderWay WayType );
native final function EnterState();
native final function ExitState();
native final function bool IsCurrentState();

native final function SetShowAndHideAnimType( bool bShow, int Direction, float Time );

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
defaultproperties
{
}
