//=============================================================================
// DemoRecSpectator - spectator for demo recordings to replicate ClientMessages
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class DemoRecSpectator extends MessagingSpectator;

var PlayerController PlaybackActor;
var GameReplicationInfo PlaybackGRI;

function ClientMessage( coerce string S, optional name Type )
{
	RepClientMessage( S, Type );
}

function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID)
{
	RepClientVoiceMessage(Sender, Recipient, messagetype, messageID);
}

function ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	RepReceiveLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

//==== Called during demo playback ============================================
/*
simulated function Tick(float Delta)
{
	local PlayerController p;
	local GameReplicationInfo g;

	// find local playerpawn and attach.
	if(Level.NetMode == NM_Client)
	{
		if(PlaybackActor == None)
		{
			foreach DynamicActors(class'PlayerController', p)
			{
				if( p.Player.IsA('Viewport') )
				{
					PlaybackActor = p;
					if(PlaybackGRI != None)
						PlaybackActor.GameReplicationInfo = PlaybackGRI;

					Log("Attached to player "$p);
					
					break;
				}
			}
		}

		if(PlaybackGRI == None)
		{
			foreach DynamicActors(class'GameReplicationInfo', g)
			{
				PlaybackGRI = g;
				if(PlaybackActor != None)
					PlaybackActor.GameReplicationInfo = PlaybackGRI;
				break;
			}
		}

		if(PlaybackActor != None && PlaybackGRI != None)
			Disable('Tick');

	}
	else
	{
		Disable('Tick');
	}
}
*/
simulated function RepClientMessage( coerce string S, optional name Type )
{	
	//if(PlaybackActor != None && PlaybackActor.Role == ROLE_Authority)
	//	PlaybackActor.ClientMessage( S, Type );
}

simulated function RepClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID)
{
	//if(PlaybackActor != None && PlaybackActor.Role == ROLE_Authority)
	//	PlaybackActor.ClientVoiceMessage(Sender, Recipient, messagetype, messageID);
}

simulated function RepReceiveLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	//if(PlaybackActor != None && PlaybackActor.Role == ROLE_Authority)
	//	PlaybackActor.ReceiveLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

replication
{
	reliable if ( bDemoRecording )
		RepClientMessage, RepClientVoiceMessage, RepReceiveLocalizedMessage;
}

defaultproperties
{
}
