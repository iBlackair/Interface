//=============================================================================
// xPickUpBase.
// This is the base class of all pickup-spawners.  When placing pickups in
// levels, place pickup bases instead since these will spawn the actual 
// pickups.
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class xPickUpBase extends Actor
    abstract
    placeable
    native;

var(PickUpBase) class<PickUp>   PowerUp;        // pick-up class to spawn with this base
var(PickUpBase) float           SpawnHeight;    // height above this base at which the power up will spawn
var(PickUpBase) class<Emitter>  SpiralEmitter;  // emitter which spawns particles when myPickup is available
var(PickUpBase) float			ExtraPathCost;	// assigned to the inventory spot
var PickUp                      myPickUp;       // reference to the pick up spawned with this base
var Emitter                     myEmitter;      // reference to the emitter spawned with this base
var	InventorySpot               myMarker;       // inventory spot marker associated with this pick-up base

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
    
    if ( PowerUp != None )
    {
		if( Level.NetMode != NM_Client )
			SpawnPickup();
		else
			PowerUp.static.StaticPrecache(Level);    
	}
			
	if( !bHidden && (Level.NetMode != NM_DedicatedServer) )
		myEmitter = Spawn(SpiralEmitter,,,Location + vect(0,0,40)); 
}

function TurnOn();

function SpawnPickup()
{
    if( PowerUp == None )
        return;

    myPickUp = Spawn(PowerUp,,,Location + SpawnHeight * vect(0,0,1));

    if (myPickUp != None)
    {
        myPickUp.PickUpBase = self;
        myPickup.Event = event;
    }
    
	if (myMarker != None)
	{
		myMarker.markedItem = myPickUp;
		myMarker.ExtraCost = ExtraPathCost;
        if (myPickUp != None)
		    myPickup.MyMarker = MyMarker;
	}
	else log("No marker for "$self);
}

defaultproperties
{
     SpawnHeight=50.000000
     DrawType=DT_Mesh
     RemoteRole=ROLE_None
     bStatic=True
     AmbientGlow=64
     CollisionRadius=35.000000
     CollisionHeight=35.000000
     bProjTarget=True
}
