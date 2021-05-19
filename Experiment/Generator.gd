extends Node

class_name Generator

var economies:Array=[]
var organizations:Array=[]
var people:Array=[]
var skills:Array=[]
var roles:Array=[]
var products:Array=[]
var recipes:Array=[]
var components:Array=[]
var processes:Array=[]

var db_root

func initialize(root):
	db_root = root
	return {
		"economies":economies,
		"organizations":organizations,
		"people":people,
		"skills":skills,
		"roles":roles,
		"products":products,
		"recipes":recipes,
		"components":components,
		"processes":processes,
	}

# Full
func generate():
	generate_processes()
	generate_components()
	generate_recipes()
	generate_products()
	generate_roles()
	generate_skills()
	generate_people()
	generate_organizations()
	generate_economy()

# Generators
func generate_economy():
	var parent = add_root_child("Economies")
	var economy = Economy.new()
	economy.name = "Countryland"
	parent.add_child(economy)
	economies.append(economy)
	for org in organizations:
		economy.connect("ping_orgs", org, "pinged")

func generate_organizations():
	var parent = add_root_child("Organizations")
	var o_names = ["SuperParts", "WalCart Co.", "DishLand Inc.", "Heckle LLC"]
	for o_name in o_names:
		var org = Organization.new()
		org.name = o_name
		parent.add_child(org)
		organizations.append(org)
		for r in rands_range(0, roles.size(), 2):
			org.connect("ping_roles", roles[r], "pinged")
		org.connect("ping_products", products[rand_range(0, products.size())], "pinged")

func generate_people():
	var parent = add_root_child("People")
	var p_names = ["John", "Carol", "Rick", "Joshua", "Fiona", "Simone"]
	for p_name in p_names:
		var person = Person.new()
		person.name = p_name
		parent.add_child(person)
		people.append(person)
		for s in rands_range(0, skills.size(), 2):
			person.connect("ping_skills", skills[s], "pinged")

func generate_skills():
	var parent = add_root_child("Skills")
	for p in range(0, processes.size()):
		var skill = Skill.new()
		parent.add_child(skill)
		skills.append(skill)
		skill.connect("ping_processes", processes[p], "pinged")

func generate_roles():
	var parent = add_root_child("Roles")
	var r_names = ["Clerk", "Waiter", "Carpenter", "Coach", "CEO", "Mayor"]
	for r_name in r_names:
		var role = Role.new()
		role.name = r_name
		parent.add_child(role)
		roles.append(role)

func generate_products():
	var parent = add_root_child("Products")
	var p_names = ["Banana", "Television", "Clay Pot", "Energy Drink"]
	var rpp:int = recipes.size() / p_names.size()
	for p in range(0, p_names.size()):
		var product = Product.new()
		parent.add_child(product)
		products.append(product)
		for r in range(0, rpp):
			product.connect("ping_recipes", recipes[p+r], "pinged")

func generate_recipes():
	var parent = add_root_child("Recipes")
	for comp in components:
		for pcss in processes:
			var recipe = Recipe.new()
			parent.add_child(recipe)
			recipes.append(recipe)
			recipe.connect("ping_components", comp, "pinged")
			recipe.connect("ping_processes", pcss, "pinged")

func generate_components():
	var parent = add_root_child("Components")
	var c_names = ["iron", "copper", "maple syrup", "cayenne pepper"]
	for c_name in c_names:
		var component = Component.new()
		component.name = c_name
		parent.add_child(component)
		components.append(component)

func generate_processes():
	var parent = add_root_child("Processes")
	var p_names = ["pulverize", "combine", "incinerate", "mix"]
	for p_name in p_names:
		var process = Process.new()
		process.name = p_name
		parent.add_child(process)
		processes.append(process)

# Helpers
func add_root_child(c_name):
	var child = Node.new()
	child.name = c_name
	db_root.add_child(child)
	return child

func rands_range(from, to, count):
	var rands:Array = []
	while (rands.size() < count):
		var rand:int = rand_range(from, to)
		if (not rands.has(rand)): rands.append(rand)
	return rands
