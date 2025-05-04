extends Node

class_name GameState

var Resources : int = 25
var TradeGoods : int = 25
var GamePhase : int = 0
var Transmutation = false
var MaxTradeGoods = 50
var MaxResources = 50
var MilitaryCapacity : Dictionary = {
	"Soldier":5,
	"Gunner":0,
	"Hound":0,
	"Cleric":0,
	"Mage":0,
	"Prisoner":0,
	"Alchemist":0,
	"Golem":0,
	"Cannon":0,
	"Skull_Dwarf":0,
	"Adventurer":0
}
var SubPhase : int = 0

var GameName : String = "NoGamenameGiven"
var GameLength : int = 0
var SessionTime : int = 0
var SaveNo : int = 0

var DWARVEN_DOMINANCE : bool = false # Kill an Ancient Monstrosity with only Soldiers and Gunners
var BEASTMASTER : int = 0 # Tame 10 Large Creatures
var YOU_SHALL_NOT_PASS : bool = false # Trap an Ancient Monstrosity with Hrudak’s Chains
var DRAGONS_ARE_OUR_FRIENDS : bool = false # Befriend a Slumbering Wyrm using Charming Colours
var ENDLESS_TREASURY : int = TradeGoods # Have 5,000 Trade Goods (♦)
var HITTING_THE_GYM : int = 0 # Increase a single unit’s STR to 200
var MIND_YOUR_STEP : bool = false # Kill an Ancient Monstrosity using nothing but Damage Traps
var LOOKING_FOR_GROUP : int = 0 # Have one of each Adventurer in your hold at the same time
var ARCHMAGE : int = 0 # Cast every spell over the course of a single hold
var PROGRESS_AT_ALL_COSTS : int = 0 # Discover every Invention, and the power of Transmutation over the course of a single hold.
