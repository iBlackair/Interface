//=============================================================================
// Ammunition: the base class of weapon ammunition
//
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class Ammunition extends Inventory
	abstract
	native
	nativereplication;

var travel int MaxAmmo;						// Max amount of ammo
var travel int AmmoAmount;
var int InitialAmount; // sjs					// Amount of Ammo current available
var travel int PickupAmmo;					// Amount of Ammo to give when this is picked up for the first time	

// Used by Bot AI

var		bool	bRecommendSplashDamage;
var		bool	bTossed;
var		bool	bTrySplash;
var		bool	bLeadTarget;
var		bool	bInstantHit;
var		bool	bSplashDamage;	


// Damage and Projectile information

var class<Projectile> ProjectileClass;
var class<DamageType> MyDamageType;
var float WarnTargetPct;
var float RefireRate;

var Sound FireSound;

var float MaxRange; // for autoaim
var bool  bTryHeadShot; 

// Network replication
//

replication
{
	// Things the server should send to the client.
	reliable if( bNetOwner && bNetDirty && (Role==ROLE_Authority) )
		AmmoAmount;
}

simulated function CheckOutOfAmmo()
{
    if (AmmoAmount <= 0)
        Pawn(Owner).Weapon.OutOfAmmo();
}

simulated function PostNetReceive()
{
    CheckOutOfAmmo();
}

simulated function bool UseAmmo(int AmountNeeded, optional bool bAmountNeededIsMax)
{
    if (bAmountNeededIsMax && AmmoAmount < AmountNeeded)
        AmountNeeded = AmmoAmount;
        
	if (AmmoAmount < AmountNeeded)
        return false;   // Can't do it
    
    AmmoAmount -= AmountNeeded;
    
    if (Level.NetMode == NM_StandAlone || Level.NetMode == NM_ListenServer)
        CheckOutOfAmmo();
	
    return true;
}

simulated function bool HasAmmo()
{
	return ( AmmoAmount > 0 );
}

function float RateSelf(Pawn Shooter, out name RecommendedFiringMode)
{
	return 0.5;
}

function WarnTarget(Actor Target,Pawn P ,vector FireDir)
{
	if ( bInstantHit )
		return;
	if ( (FRand() < WarnTargetPct) && (Pawn(Target) != None) && (Pawn(Target).Controller != None) ) 
		Pawn(Target).Controller.ReceiveWarning(P, ProjectileClass.Default.Speed, FireDir); 
}

function SpawnProjectile(vector Start, rotator Dir)
{
	AmmoAmount -= 1;
	Spawn(ProjectileClass,,, Start,Dir);	
}

function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	AmmoAmount -= 1;
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	Canvas.DrawText("Ammunition "$GetItemName(string(self))$" amount "$AmmoAmount$" Max "$MaxAmmo);
	YPos += YL;
	Canvas.SetPos(4,YPos);
}
	
function bool HandlePickupQuery( pickup Item )
{
	if ( class == item.InventoryType ) 
	{
		if (AmmoAmount==MaxAmmo) 
			return true;
		item.AnnouncePickup(Pawn(Owner));
		AddAmmo(Ammo(item).AmmoAmount);
        item.SetRespawn(); 
		return true;				
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

// If we can, add ammo and return true.  
// If we are at max ammo, return false
//
function bool AddAmmo(int AmmoToAdd)
{
	AmmoAmount = Min(MaxAmmo, AmmoAmount+AmmoToAdd);
	return true;
}

function float GetDamageRadius()
{
	if ( ProjectileClass != None )
		return ProjectileClass.Default.DamageRadius;

	return 0;
}

defaultproperties
{
     InitialAmount=10
     MyDamageType=Class'Engine.DamageType'
     WarnTargetPct=0.500000
     RefireRate=0.500000
     bNetNotify=True
}
