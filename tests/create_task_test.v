module main

import net.http

pub fn test_create_task() {
	request := http.post("http://localhost:8081/task",
		'{
			"title": "Studying",
			"description": "Studying and listen a7x",
			"status": "Doing"
		}'
	)!

	assert request.status_code == 200
}