extends Node

const CONFIG_FILE_PATH = "user://api_config.cfg"
var api_key: String = ""

func _ready() -> void:
	load_api_key()

func load_api_key():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE_PATH)
	
	# Check if the file failed to load (e.g., first run)
	if err != OK:
		print("API config file not found or corrupted. Using empty key.")
		return

	# Read the key from the file
	if config.has_section_key("api", "key"):
		api_key = config.get_value("api", "key", "")
		print("API Key loaded successfully.")
	else:
		print("API key not found in config file.")

func save_api_key(new_key: String):
	# Sanitize and store the key in memory
	api_key = new_key.strip_edges()
	
	var config = ConfigFile.new()
	
	# 1. Load existing config first (to preserve other settings)
	config.load(CONFIG_FILE_PATH)
	
	# 2. Write the new key
	config.set_value("api", "key", api_key)
	
	# 3. Save to the user data directory
	var err = config.save(CONFIG_FILE_PATH)
	
	if err != OK:
		print("ERROR: Could not save API key to file: ", err)
		return false
		
	print("API Key saved to user://api_config.cfg")
	return true
	
func does_api_key_exist() -> bool:
	return api_key != ""
