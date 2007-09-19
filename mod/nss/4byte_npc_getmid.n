//################################################
//## Laesst NPCs eine Emotion ausfuehren. In den OnSpawn teil einbauen.
//## Zustaetzlich benoetigt der NPC eine Variable Do_It >=1 !!
//## *** tribute to : 4byte aka Marcus// changed by ZuMe
//################################################



void playdead(int nRounds = 1);

void main() {
	if ( GetLocalInt(OBJECT_SELF, "Do_It") ) {
		playdead(2);
	}
}

void playdead(int nRounds = 1) {
	float nZeit = RoundsToSeconds(nRounds);
	AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, nZeit));
	if ( GetLocalInt(OBJECT_SELF, "Do_It") ) {
		DelayCommand(RoundsToSeconds(1), AssignCommand(OBJECT_SELF, playdead()));
	}
}
