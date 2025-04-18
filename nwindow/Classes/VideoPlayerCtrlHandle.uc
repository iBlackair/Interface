/**
*������Ʈ���� �⺻�� ���(���, ����, ������ ��ȯ, Ǯ��ũ��)�� ����.
*/

class VideoPlayerCtrlHandle extends WIndowHandle
	native;

/**
*������ ����Ѵ�
* @param
*void

* @return
*void

* @example
*var WindowHandle m_hMoviePlayerWnd;
*var VideoPlayerCtrlHandle MoviePlayerCtrl;
*m_hMoviePlayerWnd = GetWindowHandle( "MoviePlayerWnd" );
*MoviePlayerCtrl = GetVideoPlayerCtrlHandle("MoviePlayerWnd.MoviePlayer");	
*m_hMoviePlayerWnd.ShowWindow();
*MoviePlayerCtrl.SetFocus();
*MoviePlayerCtrl.PlayMovie();
*MoviePlayerCtrl.SetFocus();
*/

native final function PlayMovie();

/**
*��������� �����Ѵ�
* @param
*void

* @return
*void

* @example
*MoviePlayerCtrl.PlayMovie();
*MoviePlayerCtrl.SetFocus();
*........
*........
*........
*........
*MoviePlayerCtrl.EndMovie();
*/

native final function EndMovie();

/**
*����ȭ�� ũ�⸦ ������� �ǵ�����
* @param
*void

* @return
*void

* @example
*MoviePlayerCtrl.PlayMovie();
*MoviePlayerCtrl.SetFocus();
*........
*........
*........
*........
*MoviePlayerCtrl.Resize();
*/

native final function Resize();

/**
*����ȭ�� ũ�⸦ ��üȭ������ �Ѵ�
* @param
*void

* @return
*void

* @example
*MoviePlayerCtrl.PlayMovie();
*MoviePlayerCtrl.SetFocus();
*........
*........
*........
*........
*MoviePlayerCtrl.FullScreen();
*/

native final function FullScreen();
defaultproperties
{
}
