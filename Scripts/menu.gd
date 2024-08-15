extends CanvasLayer

@onready var http := $HTTPRequest

@onready var rich_text_label = $RichTextLabel

func turn_led_on():
	# Wysyłanie żądania włączenia diody LED
	http.request("http://192.168.4.1/?led=on")
	
func turn_led_off():
	# Wysyłanie żądania wyłączenia diody LED
	http.request("http://192.168.4.1/?led=off")



func _on_button_on_pressed():
	turn_led_on()


func _on_button_off_pressed():
	turn_led_off()


func _on_http_request_request_completed(result, response_code, headers, body):
	rich_text_label.text = body.get_string_from_utf8()
