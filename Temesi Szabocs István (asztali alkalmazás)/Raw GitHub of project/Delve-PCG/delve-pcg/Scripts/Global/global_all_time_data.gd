extends Node

var time_played : int
var rooms_built : int

var games_started : int
var games_lost: int
var games_won: int

var login:Dictionary = {"UID":null,"Pass":null}

var DWARVEN_DOMINANCE : bool # Kill an Ancient Monstrosity with only Soldiers and Gunners
var BEASTMASTER : bool # Tame 10 Large Creatures
var YOU_SHALL_NOT_PASS : bool # Trap an Ancient Monstrosity with Hrudak’s Chains
var DRAGONS_ARE_OUR_FRIENDS : bool # Befriend a Slumbering Wyrm using Charming Colours
var ENDLESS_TREASURY : bool # Have 5,000 Trade Goods (♦)
var HITTING_THE_GYM : bool # Increase a single unit’s STR to 200
var MIND_YOUR_STEP : bool # Kill an Ancient Monstrosity using nothing but Damage Traps
var LOOKING_FOR_GROUP : bool # Have one of each Adventurer in your hold at the same time
var ARCHMAGE : bool # Cast every spell over the course of a single hold
var PROGRESS_AT_ALL_COSTS : bool # Discover every Invention, and the power of Transmutation over the course of a single hold.
