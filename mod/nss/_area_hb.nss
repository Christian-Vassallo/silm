/*
 * File: _area_hb
 * A tag-execution based event system.
 * Copyright Bernard 'elven' Stoeckner.
 *
 * This code is licenced under the
 *  GNU/GPLv2 General Public Licence.
 */
#include "_events"

/*
 * This is a generic event distribution
 * script. Do not modify.
 */

void main() {
	RunEventScript(OBJECT_SELF, EVENT_AREA_HB, EVENT_PREFIX_AREA);
}
