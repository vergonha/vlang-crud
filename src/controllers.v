module main
import vweb

pub fn (mut app App) create_task(body string) !&Task {
	dto := TaskDto.from_body(body) or { panic(err) }
	mut task := dto.to_task() or { panic(err) }

	return task
}

pub fn (mut app App) create_task_controller(body string) vweb.Result {

	mut task := app.create_task(body) or {
		app.set_status(422, 'Unprocessable Entity')
		return app.json({"error": "${err}"})
	}

	// result := sql app.db { ... returning id } doesnt work for any reason
	query := 'insert into Task(title, description, status) values($1, $2, $3) returning id'
	insert := app.db.exec_param_many(
		query, [task.title, task.description, task.status]
	) or { panic(err) }

	task.id = insert[0].vals[0].int()
	return app.json(task)
}


pub fn (mut app App) get_task_by_id(id string) []Task {
	task := sql app.db {
		select from Task where id == id limit 1
	} or { panic(err) }

	return task
}

pub fn (mut app App) get_task_by_id_controller(id string) vweb.Result {
	task := app.get_task_by_id(id)
	return app.json(task)
}

pub fn (mut app App) get_task_by_term(term string) []Task {
	task := sql app.db {
		select from Task where (description like '%${term}%' || title like '%${term}%')
	} or { []Task{} }

	return task
}


pub fn (mut app App) get_task_by_term_controller(term string) vweb.Result {
	if term == "" {
		app.set_status(400, 'Bad Request')
        return app.json({"error": "Invalid search term."})
	}

	task := app.get_task_by_term(term)

	// maybe in future
	//query := "select * from Task where to_tsvector(title || ' ' || description) @@ plainto_tsquery('${term}');"
	//task := app.db.exec(query) or { []pg.Row{} }

	return app.json(task)
}

pub fn (mut app App) complete_task_controller(id string) vweb.Result {

	target := app.get_task_by_id(id)
	if target.len == 0 {
		app.set_status(400, 'Bad Request')
		return app.json({"error": "Invalid Task ID"})
	}

	sql app.db {
		update Task set status='Completed' where id == id
	} or { 
		app.set_status(400, 'Bad Request')
		return app.json({"error": "Error while trying to update. Double-check the Task ID."})
	}

	return app.json({"message": "Task updated successfully!"})
}

pub fn (mut app App) delete_task_controller (id string) vweb.Result {

	target := app.get_task_by_id(id)
	if target.len == 0 {
		app.set_status(400, 'Bad Request')
		return app.json({"error": "Invalid Task ID"})
	}

	sql app.db {
		delete from Task where id == id
	} or { panic(err) }

	app.set_status(200, '')
	return app.json({"message": "Task deleted successfully!"})
}