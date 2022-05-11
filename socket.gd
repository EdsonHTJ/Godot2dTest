extends Node

var client
var wrapped_client
var connected = false

var text = ""

signal setUserState(x, y, b1, b2)

func _ready():
	client = StreamPeerTCP.new()
	Socket.connect_to_server()
	
func _exit_tree():
	disconnect_from_server()

func connect_to_server():
	var ip = "192.168.1.224"
	var port = 80
	print("Connecting to server: %s : %s" % [ip, str(port)])
	var connect = client.connect_to_host(ip, port)
	if client.is_connected_to_host():
		connected = true
		print("Connected!")
	
func disconnect_from_server():
	connected = false
	client.disconnect_from_host()

func _process(delta):
	if not connected:
		pass
	if connected and not client.is_connected_to_host():
		connected = false
	if client.is_connected_to_host():
		client.set_no_delay(true)
		poll_server()


func poll_server():
	while client.get_available_bytes() > 0:
		var msg = client.get_utf8_string(client.get_available_bytes())
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
	var cmds = text.split(",")
	var cmds2 = []
	for i in range(len(cmds)):
		cmds2.append(cmds[i].split(":"))

	emit_signal("setUserState", int(cmds2[2][1]), int(cmds2[3][1]), int(cmds2[0][1]), int(cmds2[1][1]))
	
func write_text(text):
	if connected and client.is_connected_to_host():
		print("Sending: %s" % text)
		client.put_data(text.to_ascii())
