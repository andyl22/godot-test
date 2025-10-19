extends Node

signal api_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray)

var http_request: HTTPRequest

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

func start_api_request(url: String):
	var error = http_request.request(url)
	if error != OK:
		print("Error starting HTTP request: ", error)
	
	var result = await http_request.request_completed
	
	var status = result[0]
	var response_code = result[1]
	var headers = result[2]
	var body = result[3]

	if status == HTTPRequest.RESULT_SUCCESS:
		print("Request successful. HTTP Code: ", response_code)
		var json_text = body.get_string_from_utf8()
		print("Response body: ", json_text)
	else:
		print("Request failed. Result status: ", status)
		
func send_post_request(prompt, char_context):
	var base_prompt = "Respond as if you were this character, and be brief as if it were an actual conversation: %s.\n user question/statement to npc: %s"
	var finalized_prompt_with_context = base_prompt % [char_context, prompt]
	var payload = {
	  "model": "meta-llama/llama-3.3-8b-instruct:free",
	  "messages": [
		{
		  "role": "user",
		  "content": finalized_prompt_with_context
		}
	  ]
	}
	
	var auth = ApiConfig.api_key
	var error = http_request.request(
		"https://openrouter.ai/api/v1/chat/completions",
		[
			"Content-Type: application/json",
			"Authorization: Basic %s" % auth
		],
		HTTPClient.METHOD_POST,
		JSON.stringify(payload)
	)
	
	if error != OK:
		print("Error starting HTTP request: ", error)
	
	var result = await http_request.request_completed
	
	var status = result[0]
	var response_code = result[1]
	var headers = result[2]
	var body = result[3]

	if status == HTTPRequest.RESULT_SUCCESS:
		print("Request successful. HTTP Code: ", response_code)
		var json_text = body.get_string_from_utf8()
		print("Response body: ", json_text)
	else:
		print("Request failed. Result status: ", status)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	api_request_completed.emit(result, response_code, headers, body)
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		var body_text = body.get_string_from_utf8()
