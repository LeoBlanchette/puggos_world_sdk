Use this avatar to set up item anchor settings without hurting / interfering with
res://addons/puggos_world_character/avatar/avatar.tscn 

Simply set an item (such as knife or junk) as a child of Anchor_Slot_<i>,
then, with the item selected, push the "Generate Item / Anchor Offsets" button.
That will write meta data to the node regarding it's placement in the anchor.
Then, when the game loads it to that particular anchor point, it will be offset 
properly, according to how you positioned it.
