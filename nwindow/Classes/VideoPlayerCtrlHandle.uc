/**
*비디오컨트롤의 기본적 기능(재생, 종료, 사이즈 변환, 풀스크린)을 정의.
*/

class VideoPlayerCtrlHandle extends WIndowHandle
	native;

/**
*비디오를 재생한다
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
*비디오재생를 종료한다
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
*비디오화면 크기를 원래대로 되돌린다
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
*비디오화면 크기를 전체화면으로 한다
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
