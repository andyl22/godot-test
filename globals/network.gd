extends Node

signal api_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray)

var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

func start_api_request(url: String):
	var error = http_request.request(url)
	if error != OK:
		print("Error starting HTTP request: ", error)
		
func send_post_request(prompt):
	var data = {
	  "servingId": {
		"modelId": {
		  "model": "<string>",
		  "serviceProvider": "SERVICE_PROVIDER_UNSPECIFIED"
		},
		"userId": "<string>",
		"sessionId": "<string>"
	  },
	  "messages": [
		{
		  "content": "<string>",
		  "role": "MESSAGE_ROLE_UNSPECIFIED",
		  "toolCalls": [
			{
			  "id": "<string>",
			  "functionCall": {
				"name": "<string>",
				"args": "<string>"
			  }
			}
		  ],
		  "toolCallId": "<string>",
		  "name": "<string>",
		  "textContent": "<string>",
		  "contentItems": {
			"contentItems": [
			  {
				"text": "<string>",
				"imageUrl": {
				  "url": "<string>",
				  "detail": "<string>"
				}
			  }
			]
		  }
		}
	  ],
	  "tools": [
		{
		  "functionCall": {
			"name": "<string>",
			"description": "<string>",
			"properties": {}
		  }
		}
	  ],
	  "toolChoice": {
		"text": "<string>",
		"object": {
		  "functionCall": {
			"name": "<string>"
		  }
		}
	  },
	  "textGenerationConfig": {
		"frequencyPenalty": 123,
		"logitBias": [
		  {
			"tokenId": "<string>",
			"biasValue": 123
		  }
		],
		"maxTokens": 123,
		"n": 123,
		"presencePenalty": 123,
		"stop": [
	      "<string>"
		],
		"stream": true,
		"temperature": 123,
		"topP": 123,
		"repetitionPenalty": 123,
		"seed": 123
	  },
	  "responseFormat": "RESPONSE_FORMAT_UNSPECIFIED",
	  "requestTimeout": 123,
	  "jsonSchema": {
		"name": "<string>",
		"description": "<string>",
		"strict": true,
		"schema": {}
	  }
	}
	var auth = "test"
	var json_string = JSON.stringify(data)
	var body_bytes = json_string.to_utf8_buffer()
	
	var error = http_request.request(
		"https://api.inworld.ai/llm/v1alpha/completions:completeChat",
		[
			"Content-Type: application/json",
			"Authorization: %s" % auth
		],
		HTTPClient.METHOD_POST,
		body_bytes
	)
	
	if error != OK:
		print("Error starting POST request: ", error)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	api_request_completed.emit(result, response_code, headers, body)
	
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		var body_text = body.get_string_from_utf8()
