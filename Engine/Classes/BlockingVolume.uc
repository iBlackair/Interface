//=============================================================================
// BlockingVolume:  a bounding volume
// used to block certain classes of actors
// primary use is to provide collision for non-zero extent traces around static meshes 
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class BlockingVolume extends Volume
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() bool bClampFluid;
var() bool bClassBlocker; // sjs
var() Array< class<Actor> > BlockedClasses; // sjs

defaultproperties
{
     bClampFluid=True
     bWorldGeometry=True
     bBlockActors=True
     bBlockPlayers=True
     bBlockZeroExtentTraces=False
     bBlockKarma=True
}
