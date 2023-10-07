extends Control

var text: String = "asdasdasdasd"

var customers = [
	CustomerData.new(
		"Grumpy lumberman",
		"Brr, the weather is rather familiar, but this country has nothing to offer me. Pff, a tea shop?!? The audacity...",
		[
			"I feel tired, let's see if you could give me some caffeine. (black tea // mate tea)",
			"So you think you know tea, lad? Same tea as last time, but make it spicy! (bergamot // cloves)",
			"Gives me energy, has some spice, but the taste of home is what your tea is still missing. (milk // whisky)"
		],
		[
			"Bloody hell, this isn't what I asked for, mate! ",
			"Sorry... That's just not my cup of tea.",
			"Bleee, this is far from the King's standard, innit?"
		],
		[
			"Just what the doctor ordered!",
			"Sugar, spice, and everything nice! (Except for the sugar, let's keep that for the Americans.)",
			"Oh my Lord, you did it. It's bloody brilliant. I must assume you also have some history exploiting other sub-continents for centuries to have this level of knowledge of tea making in your blood."
		],
		"res://images/characthers/CozyJam2023_paintergirl.png"
	)
]

func _ready():
	var tween = get_tree().create_tween()
	
	tween.tween_property($Panel/MarginContainer/RichTextLabel, "visible_ratio", 1, 3)
	
	pass # Replace with function body.

func _process(delta):
	pass


func _on_button_make_tea_pressed():
	SceneTransition.change_scene_to_file("res://scenes/teamaking_scene.tscn")
	pass # Replace with function body.
