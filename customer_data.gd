class_name CustomerData extends Node2D

var customerName: String
var customerStarterMessage: String
var customerCurrentLevel: int
var customerOrderDialogs
var customerOrderRejectionDialogs
var customerOrderAcceptDialogs
var customerImage: String
var introFinished: bool
var correctItems

func _init(name, starter, orderDialogs, rejectionDialogs, acceptDialogs, imagePath, items):
	self.customerName = name
	self.customerStarterMessage = starter
	self.customerCurrentLevel = 0
	self.introFinished = false
	self.customerOrderDialogs = orderDialogs
	self.customerOrderRejectionDialogs = rejectionDialogs
	self.customerOrderAcceptDialogs = acceptDialogs
	self.customerImage = imagePath
	self.correctItems = items
	pass

func get_current_order_dialog():
	return customerOrderDialogs[customerCurrentLevel]

func get_current_accept_dialog():
	return customerOrderAcceptDialogs[customerCurrentLevel]

func get_current_reject_dialog():
	return customerOrderRejectionDialogs[customerCurrentLevel]
	

