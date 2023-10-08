module main
import json


[table: 'task']
pub struct Task {
		title 		string 	[nonnull; sql_type: 'VARCHAR(24)']
		description 	string 	[sql_type: 'VARCHAR(256)']
		status 		string 	[sql_type: 'VARCHAR(16)']
	mut:
		id		int	[primary; sql_type: serial]

}

pub struct TaskDto { 
		title		string	[json: title; required]
		description	string	[json: description]
		status		string	[json: status]
	mut:
		id		int	[json: id]

}

fn (t Task) to_dto() &TaskDto {
	return &TaskDto{
		title: t.title
		description: t.description
		status: t.status
	}
}

fn (t Task) to_json() string {
	return json.encode(t)
}

fn TaskDto.from_body(body string) !&TaskDto {
	mut dto := json.decode(TaskDto, body)!
	
	if dto.title.len > 24 {
		return error("Invalid title length.")
	}

	if dto.description.len > 256 {
		return error("Invalid description length.")
	}

	if dto.status.len > 16 {
		return error("Invalid status length.")
	}

	return &dto
}

fn (d TaskDto) to_task() !&Task {
	return &Task {
		title: d.title
		description: d.description
		status: d.status
	}
}
