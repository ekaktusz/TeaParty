extends Node
var currentCustomer: int = 0

var inactiveCustomers = [
	
]
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
			["Black Tea", "Mate Tea"]
		]
	)
]

func removeCurrentCustomer():
	self.getCurrentCustomer().reset()
	self.inactiveCustomers.append(self.getCurrentCustomer())
	self.customers.erase(self.getCurrentCustomer())

func getCurrentCustomer() -> CustomerData:
	if CustomerDatabase.customers.size() == 0:
		return null
	return self.customers[self.currentCustomer]
	
func nextCustomer():
	if (CustomerDatabase.customers.size() == 1):
		return
	
	var nextCustomerId = randi() % self.customers.size()
	while (nextCustomerId == self.currentCustomer):
		nextCustomerId = randi() % self.customers.size()
	
	CustomerDatabase.currentCustomer = nextCustomerId
	return
