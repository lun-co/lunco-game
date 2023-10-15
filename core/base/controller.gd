class_name LCController
extends LCSpaceSystem

var controller_authority_id := -1

signal requesting_controller_authority(_controller, owner)
signal releasing_controller_authority(_controller, owner)

signal control_granted_n(_controller, owner)
signal control_declined_n(_controller, owner)

@rpc("any_peer", "call_local")
func set_authority(owner):
	print("Setting authority ", multiplayer.get_remote_sender_id()  )
	print("Setting authority owner ", owner )
	get_parent().set_multiplayer_authority(owner)

@rpc("any_peer", "call_local")
func set_controller_authority_id(_controller_authority_id):
	print("set_controller_authority_id")
	controller_authority_id = _controller_authority_id

@rpc("any_peer", "call_local")
func request_controller_authority():
	print('request_controlle_authority')
	requesting_controller_authority.emit(self, multiplayer.get_remote_sender_id())
	#controller_authority_id = _controller_authority_id

@rpc("any_peer", "call_local")
func release_controller_authority():
	print("release_controller_authority")
	releasing_controller_authority.emit(self, multiplayer.get_remote_sender_id())

@rpc("any_peer", "call_local")
func control_granted_notify():
	print("control_granted_notify remote: ", multiplayer.get_remote_sender_id(), " local: ", multiplayer.get_unique_id())
	control_granted_n.emit(self, multiplayer.get_remote_sender_id())

@rpc("any_peer", "call_local")
func control_declined_notify():
	control_declined_n.emit(self, multiplayer.get_remote_sender_id())
	
#--------------------------------------------
## 
static func find_controller(entity: Node) -> LCController:
	var target: LCController
	
	if entity:
		for N in entity.get_children():
			if N is LCController:
				target = N
				break
			
	return target
