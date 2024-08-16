extends CanvasLayer


#przycisk do debugu lewy gurny rug
@onready var button_debug := $Button_debug/Buttons_light
#czerwony przycisk among us
@onready var button_red_on_rocket = $Button_Red_ON_ROCKET
#http requesty
@onready var http := $HTTPRequest
#animacja pokrywy
@onready var animation_player := $Klapa3d/SubViewportContainer/SubViewport/AnimationPlayer
#grren orange red 
@onready var color_sprawdza = $ColorSprawdza

var timeredstatus := true
@onready var timer_red := $Timer_red
@onready var timer_red_fireup := $Timer_red_fireup

#debug visible
var bvisible: bool = true

var animationfinishedbool := true

var opencase: int = 1


var redbuttonpreset := false
@onready var video_stream_player = $VideoStreamPlayer

#funkcje wlaczenie i wylaczenie leda
func turn_led_on():
	# Wysyłanie żądania włączenia diody LED
	http.request("http://192.168.4.1/?led=on")
	
func turn_led_off():
	# Wysyłanie żądania wyłączenia diody LED
	http.request("http://192.168.4.1/?led=off")
	

func turn_relay_on():
	http.request("http://192.168.4.1/?relay=on")


func turn_relay_off():
	http.request("http://192.168.4.1/?relay=off")

# 3 state 1 = green 2 = orange itd
func _process(_delta):
	#print(animationfinishedbool)
	
	if redbuttonpreset == true:
		opencase = 4
		timer_red.stop()
	
	if opencase == 1:
		color_sprawdza.set_color("green")
		button_red_on_rocket.disabled = true
		timer_red.stop()
	if opencase == 2:
		color_sprawdza.set_color("orange")
		button_red_on_rocket.disabled = true
		timer_red.stop()
	if opencase == 3:
		color_sprawdza.set_color("red")
		button_red_on_rocket.disabled = false
		if timeredstatus == true:
			timeredstatus = false
			timer_red.start()



#button debug left up corner
func _on_button_on_pressed():
	turn_led_on()

func _on_button_off_pressed():
	turn_led_off()




#mysz weszla
func _on_klapka_mouse_entered():
	if animationfinishedbool == true and opencase == 1:
		animation_player.play("Open")
		animationfinishedbool = false
		opencase = 2

func _on_klapka_mouse_exited():
	if animationfinishedbool == true:
		pass




# animacje
func _on_animation_player_animation_finished(anim_name):
	animationfinishedbool = true
	if anim_name == ("Close"):
		opencase = 1
	if anim_name == ("Open"):
		opencase = 3


func _on_button_debug_pressed():
	bvisible =! bvisible
	button_debug.visible = !bvisible


func _on_timer_red_timeout():
	animation_player.play("Close")
	opencase = 2
	animationfinishedbool = true
	timeredstatus = true

#warning!!!!
func _on_button_red_on_rocket_pressed():
	#warning!!!!
	opencase = 4
	button_red_on_rocket.disabled = true
	redbuttonpreset = true
	timer_red_fireup.start()
	turn_relay_on()
	video_stream_player.play()
	


func _on_timer_red_fireup_timeout():
	turn_relay_off()


func _on_button_restart_pressed():
	get_tree().change_scene_to_file("res://Scens/menu.tscn")


func _on_button_relay_on_pressed():
	turn_relay_on()


func _on_button_relay_off_pressed():
	turn_relay_off()
