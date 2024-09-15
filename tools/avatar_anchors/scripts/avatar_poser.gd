@tool
class_name AvatarPoser
extends SkeletonModifier3D


@export var skeleton_3d: Skeleton3D 
@export var animation_player:AnimationPlayer

var pose_set:bool = false
var bone_list:Array[String]=[]
var animation:Animation = null
const skel_path = "Armature/Skeleton3D:"

func set_avatar_pose(_animation:Animation):	
	pose_set = false
	animation_player.active = false
	active = true
	influence = 1
	skeleton_3d.show_rest_only = false
	animation = _animation
	populate_bone_list()

	
## Populates the bone list so that the avatar poser does not
## attempt to animate bones that may not exist.
func populate_bone_list():
	bone_list = []
	for bone_idx:int in range(0, skeleton_3d.get_bone_count()):
		var bone_name:String = skeleton_3d.get_bone_name(bone_idx)
		if not bone_list.has(bone_name):
			bone_list.append(bone_name)

	
## Sets the bone name / track index of the playing animation. Fires once 
## when a custom animation is played.
func set_temporary_track_index():
	
	var c:int = animation.get_track_count()
	for i in range(c):
		var t_path:String = animation.track_get_path(i)
		var bone_name:String = t_path.replace(skel_path, "")
		bone_name = bone_name.split(":")[-1]

func _process_modification() -> void:
	if pose_set:
		return
	var skeleton: Skeleton3D = get_skeleton()
	if !skeleton:
		return # Never happen, but for the safety.
	if animation == null:
		return
	merge_current_animation(skeleton)
	pose_set = true

func merge_current_animation(skeleton: Skeleton3D):
	var time:float =0

	for bone in bone_list:	
		var rot:Quaternion = get_rotation_at_time(bone, time)
		var pos:Vector3 = get_position_at_time(bone, time)
		var sca:Vector3 = get_scale_at_time(bone, time)
		
		var bone_idx: int = skeleton.find_bone(bone)
		if rot != Quaternion.IDENTITY:
			skeleton.set_bone_pose_rotation(bone_idx, rot)
		if pos != Vector3.ZERO:
			skeleton.set_bone_pose_position(bone_idx, pos)
		if sca != Vector3.ZERO:
			skeleton.set_bone_pose_scale(bone_idx, pos)

func get_rotation_at_time(bone:String, time:float)->Quaternion:
		
		var track_idx:int = animation.find_track(skel_path+bone, Animation.TYPE_ROTATION_3D)
		
		if track_idx == -1:
			return Quaternion.IDENTITY
		var rot:Quaternion = animation.rotation_track_interpolate(track_idx, time)
		return rot 
	
func get_position_at_time(bone:String, time:float)->Vector3:
		var track_idx:int = animation.find_track(skel_path+bone, Animation.TYPE_POSITION_3D)
		
		if track_idx == -1:
			return Vector3.ZERO
		var pos:Vector3 = animation.position_track_interpolate(track_idx, time)
		return pos 
		
func get_scale_at_time(bone:String, time:float)->Vector3:
		var track_idx:int = animation.find_track(skel_path+bone, Animation.TYPE_SCALE_3D)
		if track_idx == -1:
			return Vector3.ZERO		
		var sca:Vector3 = animation.scale_track_interpolate(track_idx, time)
		return sca 
