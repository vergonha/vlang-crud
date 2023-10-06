module main

import net.http
import json

struct Response {
	title 			string
	description 	string
	status 			string
	id 				int
}

pub fn test_create_task() {
	request := http.get_text("http://localhost:8081/task/1")
	task := json.decode([]Response, request)!

	assert task[0].title == "Studying"
}