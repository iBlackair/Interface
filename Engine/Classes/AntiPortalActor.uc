//=============================================================================
// AntiPortalActor.
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class AntiPortalActor extends Actor
	native
	placeable;

//
//	TriggerControl
//

state() TriggerControl
{
	// Trigger

	event Trigger(Actor Other,Pawn EventInstigator)
	{
		SetDrawType(DT_None);
	}

	// UnTrigger

	event UnTrigger(Actor Other,Pawn EventInstigator)
	{
		SetDrawType(DT_AntiPortal);
	}
}

//
//	TriggerToggle
//

state() TriggerToggle
{
	// Trigger

	event Trigger(Actor Other,Pawn EventInstigator)
	{
		if(DrawType == DT_AntiPortal)
			SetDrawType(DT_None);
		else if(DrawType == DT_None)
			SetDrawType(DT_AntiPortal);
	}
}

//
//	Default properties
//

defaultproperties
{
     DrawType=DT_AntiPortal
     RemoteRole=ROLE_None
     bNoDelete=True
     bEdShouldSnap=True
}
