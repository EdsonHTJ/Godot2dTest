extends Node

var client1
var client2
var wrapped_client
var connected = false

var text = ""

signal setUserState(x, y, b1, b2)

func _ready():
	client1 = StreamPeerTCP.new()
	client2 = StreamPeerTCP.new()
	client1.set_no_delay(true)
	client2.set_no_delay(true)
	Socket.connect_to_server()
	
func _exit_tree():
	disconnect_from_server()

func connect_to_server():
	var ip = "192.168.237.240"
	var ip2 = "192.168.237.220"
	var port = 80
	print("Connecting to server: %s : %s" % [ip, str(port)])
	var connect = client1.connect_to_host(ip, port)
	if client1.is_connected_to_host():
		connected = true
		print("Connected!")
	print("Connecting to server: %s : %s" % [ip2, str(port)])
	var connect2 = client2.connect_to_host(ip2, port)
	if client2.is_connected_to_host():
		connected= true
		print("Connected!")
	
func disconnect_from_server():
	connected = false
	client1.disconnect_from_host()

func _process(delta):
	if not connected:
		pass
	if connected and not client1.is_connected_to_host():
		connected = false
	if client1.is_connected_to_host():
		client1.set_no_delay(true)
		client2.set_no_delay(true)
		poll_server(client1)
		poll_server(client2)


func poll_server(cl):
	while cl.get_available_bytes() > 0:
		var msg = cl.get_utf8_string(cl.get_available_bytes())
		print(msg)
		if msg == null:
			continue;
			
		if msg.length() > 0:
			for c in msg:
				if c == "\n":
					on_text_received(text)
					text = ""
				else:
					text+=c

func on_text_received(text): #"1 Sobe"
	var cmds = text.split(" ")
	
	var isAtk = 0
	if cmds[0] == "ATK":
		isAtk = 1
	var movx = 0xff
	var movy = 0xff
	
	if cmds[0] == "MOV":
		movx = int(cmds[1])
		
	var isJmp = 0
	if cmds[0] == "JMP":
		isJmp = 1
	

	emit_signal("setUserState", movx, 0, isJmp, isAtk)
	
func write_text(text):
	if connected and client1.is_connected_to_host():
		print("Sending: %s" % text)
		client1.put_data(text.to_ascii())
