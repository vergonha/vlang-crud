module main

import net.http


pub fn test_delete_task() {
	request := http.delete("http://localhost:8081/task/1") or { panic(error) }

	assert request.status_code == 200
}