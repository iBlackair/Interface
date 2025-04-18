//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class WeaponAttachment extends InventoryAttachment
	native
	nativereplication;

var		byte	FlashCount;			// when incremented, draw muzzle flash for current frame
var		byte	FiringMode;			// replicated to identify what type of firing/reload animations to play
var		byte	SpawnHitCount;		// when incremented, spawn hit effect at mHitLocation
var		bool	bAutoFire;			// When set to true.. begin auto fire sequence (used to play looping anims)
var		float	FiringSpeed;		// used by human animations to determine the appropriate speed to play firing animations
var		vector  mHitLocation;		// used for spawning hit effects client side

replication
{
	// Things the server should send to the client.
	reliable if( bNetDirty && !bNetOwner && (Role==ROLE_Authority) )
		FlashCount, FiringMode, bAutoFire;

	reliable if ( bNetDirty && (Role==ROLE_Authority) )
		mHitLocation, SpawnHitCount;
}

/* 
ThirdPersonEffects called by Pawn's C++ tick if FlashCount incremented
becomes true
OR called locally for local player
*/
simulated event ThirdPersonEffects()
{
	// spawn 3rd person effects

	// have pawn play firing anim
	if ( Instigator != None )
	{
		if ( FiringMode == 1 )
			Instigator.PlayFiring(1.0,'1');
		else
			Instigator.PlayFiring(1.0,'0');
	}
}

/* UpdateHit
- used to update properties so hit effect can be spawn client side
*/
function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal);

defaultproperties
{
     FiringSpeed=1.000000
     bActorShadows=True
     bReplicateInstigator=True
}
