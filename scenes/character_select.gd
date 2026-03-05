extends Control

var wybrana_postac = ""

func _on_Lukasz_pressed():
	wybrana_postac = "Lukasz"
	print("Wybrano Lukasza")

func _on_Patryk_pressed():
	wybrana_postac = "Patryk"
	print("Wybrano Patryka")

func _on_Shimmy_pressed():
	wybrana_postac = "Shimmy"
	print("Wybrano Shimmyego")
	
func _on_Igor_pressed():
	wybrana_postac = "Igor"
	print("Wybrano Igora")

func _on_Dzony_pressed():
	wybrana_postac = "Dzony"
	print("Wybrano Dzonego")

func _on_start_pressed():
	if wybrana_postac != "":
		print("Start gry z postacią: " + wybrana_postac)
