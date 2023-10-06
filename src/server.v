module main
import db.pg
import vweb


struct App {
		vweb.Context
		db_handle vweb.DatabasePool[pg.DB][required]
	mut:
		db pg.DB
}

fn get_connection() pg.DB {
	return pg.connect(pg.Config{
			host: '127.0.0.1'
			port: 5432
			user: 'postgres'
			password: 'dev'
			dbname: 'postgres'
		}) or { panic(err) }
}	

fn main() {
	vweb.run_at(new_app(), vweb.RunParams{
		port: 8081
	}) or { panic(err) }
}

fn new_app() &App {
	pool := vweb.database_pool(handler: get_connection)
	mut app := &App{
		db_handle: pool
	}
	return app
}
