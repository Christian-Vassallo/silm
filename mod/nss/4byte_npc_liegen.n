//################################################
//## Laesst NPCs schlafend liegen. In den OnSpawn teil einbauen.
//## Zustaetzlich benoetigt der NPC eine Variable SAVE_DEAD_BACK >=1 !!
//## *** tribute to : 4byte aka Marcus
//################################################



void playdead(int nRounds = 1);

void main() {
	if ( GetLocalInt(OBJECT_SELF, "SAVE_DEAD_BACK") ) {
		playdead(2);
	}
}

void playdead(int nRounds = 1) {
	float nZeit = RoundsToSeconds(nRounds);
	AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, nZeit));
	// AssignCommand(OBJECT_SELF, ActionSpeakString("Zzzz...zzz"));
	if ( GetLocalInt(OBJECT_SELF, "SAVE_DEAD_BACK") ) {
		DelayCommand(RoundsToSeconds(1), AssignCommand(OBJECT_SELF, playdead()));
	}
}
