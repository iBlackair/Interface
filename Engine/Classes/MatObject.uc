//=============================================================================
// MatObject
//
// A base class for all Matinee classes.  Just a convenient place to store
// common elements like enums.
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class MatObject extends Object
	abstract
	native;

struct Orientation
{
	var() ECamOrientation	CamOrientation;
	var() actor LookAt;
	var() actor DollyWith;
	var() float EaseIntime;
	var() int bReversePitch;
	var() int bReverseYaw;
	var() int bReverseRoll;

	var int MA;
	var float PctInStart, PctInEnd, PctInDuration;
	var rotator StartingRotation;
};

defaultproperties
{
}
