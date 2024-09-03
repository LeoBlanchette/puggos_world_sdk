Place the Blender file in here with 1 animation. In the import settings 
(gotten by double-clicking the blender file from within the editor)
set your animation export to the <object> root folder, as shown at the end of this 
file path:

</mods/<creator>/<project>/<mod_type>/<mod_type_category>/<object>/<object>.tscn , .png | etc

Then animation should export to that folder with every change to the .blend.

IMPORTANT: Only export 1 animation for each folder. Multiple animations require
multiple folders, named appropriately, with the same setup. The FOLDER should match 
the animation name. The animation name should match the folder. This way the mod 
importer (asset loader) can find it. 

Also provide an animation.tscn to hold the meta information. Standard practice.
(even though the <animation>.res can hold meta infomation, it could be over-written
by the automated mod export.)
