extends Resource

class_name ModInfo

## This is the id of the actual steam item / mod. It is known after uploading.
@export var mod_id:int = 0

## Name of the mod as it will appear in the workshop title.
@export var mod_name:String = "A Puggo's World Mod"

## The preview image of the mod. Important. Use a pug if can?
@export var mod_preview_image:Texture2D = null

## URLs you would like your users to see in regard to your work / mod.
@export var urls:PackedStringArray = [
	"https://steamcommunity.com/app/2414160/",
	"https://steamcommunity.com/app/2414160/workshop/"
	]
