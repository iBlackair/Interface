//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class PotentialClimbWatcher extends Info
	native;

simulated function Tick(float DeltaTime)
{
	local rotator PawnRot;
	local LadderVolume L;
	local bool bFound;

	if ( (Owner == None) || Owner.bDeleteMe || !Pawn(Owner).CanGrabLadder() )
	{
		destroy();
		return;
	}

	PawnRot = Owner.Rotation;
	PawnRot.Pitch = 0;
	ForEach Owner.TouchingActors(class'LadderVolume', L)
		if ( L.Encompasses(Owner) )
		{
			if ( (vector(PawnRot) Dot L.LookDir) > 0.9 )
			{
				Pawn(Owner).ClimbLadder(L);
				destroy();
				return;
			}
			else
				bFound = true;
		}

	if ( !bFound )
		destroy();
}

defaultproperties
{
}
