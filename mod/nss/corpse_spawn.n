void main() {
	SetLocalInt(OBJECT_SELF, "CUSTOM_CORPSE", 1);
	SetLocalFloat(OBJECT_SELF, "DESTRUCT_TIME", 180.0f);

	/*
	 * If the creature is a plot creature, make it still killable but not
	 * not completely destroyable.
	 */
	if ( GetPlotFlag(OBJECT_SELF) ) {
		SetPlotFlag(OBJECT_SELF, FALSE);
		SetLocalInt(OBJECT_SELF, "PLOT_FLAG", 1);
	}
}


