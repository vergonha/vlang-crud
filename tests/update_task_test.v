module main

import net.http
import json

struct Response {
	message 	string
}

pub fn test_update_task() {
	request := http.get_text("http://localhost:8081/complete?id=1")
	response := json.decode(Response, request)!

	assert response.message == "Task updated successfully!" 
}