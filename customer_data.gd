class_name CustomerData extends Node2D

var customerName: String
var customerStarterMessage: String
var customerCurrentLevel: int
var customerOrderDialogs
var customerOrderRejectionDialogs
var customerOrderAcceptDialogs
var customerImage: String
var introFinished: bool

func _init(name, starter, orderDialogs, rejectionDialogs, acceptDialogs, imagePath):
	self.customerName = name
	self.customerStarterMessage = starter
	self.customerCurrentLevel = 0
	self.introFinished = false
	self.customerOrderDialogs = orderDialogs
	self.customerOrderRejectionDialogs = rejectionDialogs
	self.customerOrderAcceptDialogs = acceptDialogs
	self.customerImage = imagePath
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
