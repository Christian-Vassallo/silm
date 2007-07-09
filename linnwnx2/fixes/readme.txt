NWNX Fixes 1.0

This plugin is intended to provide various fixes and patches to NWServer.

The first fix in 1.0:
- The engine now takes local variables into account when working with stackable items:
 * Items with different local vars don't stack
 * When you split a stack, all vars get copied
 * When you buy an item marked as infinite from a store, the vars also get copied

In future releases the plugin will be configurable.

---
virusman, 09.07.2007