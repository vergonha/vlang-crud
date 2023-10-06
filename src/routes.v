module main
import vweb


['/task'; post]
pub fn (mut app App) create() vweb.Result {
	return app.create_task_controller(app.req.data)
}


['/task/:id'; get]
pub fn (mut app App) task_by_id(id string) vweb.Result {
	return app.get_task_by_id_controller(id)
}

['/task/:id'; delete]
pub fn (mut app App) delete_task(id string) vweb.Result {
	return app.delete_task_controller(id)
}


['/task'; get]
pub fn (mut app App) task_by_description() vweb.Result {
	term := app.query['term'] or { "" }
	return app.get_task_by_term_controller(term)
}


['/complete'; get]
pub fn (mut app App) complete() vweb.Result {
	return app.complete_task_controller(app.query['id'] or { "" })
}