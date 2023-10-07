class_name PropData extends Node2D

var propName: String
var propIconPath: String
var propCardPath: String

func _init(inName, iconPath, cardPath):
	self.propName = inName
	self.propIconPath = iconPath
	self.propCardPath = cardPath

