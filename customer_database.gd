extends Node
var currentCustomer: int = 0
var customers = [
	CustomerData.new(
		"Grumpy lumberman",
		"Brr, the weather is rather familiar, but this country has nothing to offer me. Pff, a tea shop?!? The audacity...",
		[
			"I feel tired, let's see if you could give me some [b][i]caffeine[/i][/b].",
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
		"res://images/characthers/CozyJam2023_lumberjack.png",
		[
			["Black Tea", "Mate Tea"],
			["Bergamot", "Cloves"],
			["Milk", "Whiskey"]
		]
	),
	CustomerData.new(
		"Heartbroken Butcher",
		"Greetings! You know me, you buy meat at my shop. Anyway... those were better days... My gal just left me! What am I supposed to do now?!",
		[
			"To be honest I don't even care, just give me something that resembles the colors of different seasons, when life was happier... (green tea // white tea)",
			"Hey... Now that you got the colors right, could you put in some sour stuff to better match my mood? (lemon // vinegar)",
			"I like the color, the sourness is just fine, and I don't need salt, my tears are enought... Oh I see a girls name in your inventory though... (Rose petals // Jasmine petals)"
		],
		[
			"It tastes just how I feel. Awful!",
			"But not like this! Eww...",
			"Pfff, what is this, poision? I wish, that would end my suffer."
		],
		[
			"From winter to spring, we were together. Thanks!",
			"If I could be enthusiastic about anything, I would really like this tea.",
			"Hmm...it....works? My hearth is healed, my mind is cleared. You are a magician young man. I'm ready to swipe again. Who's that chick in the corner?"
		],
		"res://images/characthers/CozyJam2023_Butcher_happy.png",
		[
			["Green Tea", "White Tea"],
			["Lemon", "Vinegar"],
			["Rose Petals", "Jasmine Petals"]
		]
	),
	CustomerData.new(
		"Witch Girl",
		"I gotta get my homework done quick, or my master will surely turn me into a mouse... But maybe a cup of tea could help the creative juices flowing. ",
		[
			"Hey, mister. I wanna drink something that makes me extra bouncy/jumpy. (frogleg // roiboss)",
			"I loved the jumpy juice! Can you also add something small and adorable to it (like me)? Pretty please! (lizard liver // poppy seed)",
			"Okay. Jumpy - check. Smol - check. Now, I want you to add something MAGICAL to the mix! (unicorn feather (szivárványszínű) // water of life)"
		],
		[
			"Eww! I don't want it!",
			"Mom, can you come and pick me up? :(",
			"That ain't magic, mister. "
		],
		[
			"Ah! That sure was something, mister.",
			"Ah! Just what I needed.",
			"Muhahaha! FOOL! You did it! YOU DID IT FOR ME! You finished my homework without even knowing. See ya, nerd!"
		],
		"res://images/characthers/CozyJam2023_Kid_happy.png",
		[
			["Frogleg", "Roiboss"],
			["Lizar Liver", "Poppy Seed"],
			["Unicorn Feather", "Water Of Life"]
		]
	)
	
]

func removeCurrentCustomer():
	for item in self.customers:
		if item.customerName == self.getCurrentCustomer().customerName:
			self.customers.remove(item)

func getCurrentCustomer() -> CustomerData:
	return self.customers[self.currentCustomer]
	
func nextCustomer():
	if self.getCurrentCustomer().customerCurrentLevel > 3:
		removeCurrentCustomer()
	
	var nextCustomerId = randi() % self.customers.size()
	while (nextCustomerId == self.currentCustomer):
		nextCustomerId = randi() % self.customers.size()
	
	CustomerDatabase.currentCustomer = nextCustomerId
	return

