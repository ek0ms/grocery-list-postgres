
###EXCEEDS EXPECTATIONS

require "sinatra"
require "pg"
require "pry"

configure :development do
  set :db_config, { dbname: "grocery_list_development" }
end

configure :test do
  set :db_config, { dbname: "grocery_list_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

def groceries_all
  db_connection do |conn|
    sql_query = "SELECT * FROM groceries"
    conn.exec(sql_query)
  end
end

def groceries_save(params)
  unless params["name"].empty?
    db_connection do |conn|
      sql_query = "INSERT INTO groceries (name) VALUES ($1)"
      data = [params["name"]]
      conn.exec_params(sql_query, data)
    end
  end
end

def groceries_find(id)
  db_connection do |conn|
    sql_query = "SELECT * FROM groceries WHERE id = $1"
    data = [id]
    conn.exec_params(sql_query, data).first
  end
end

def groceries_comments(id)
  db_connection do |conn|
    sql_query = "SELECT groceries.*, comments.* FROM groceries
        JOIN comments ON groceries.id = comments.grocery_id
        WHERE groceries.id = $1"
    data = [id]
    conn.exec_params(sql_query, data)
  end
end

def groceries_delete(id)
  db_connection do |conn|
    sql_query = "DELETE FROM groceries WHERE id =$1"
    data = [id]
    conn.exec_params(sql_query, data)
  end
end

def groceries_update(id, name)
  db_connection do |conn|
    sql_query = "UPDATE groceries SET name=$2 WHERE id=$1"
    data = [id, name]
    conn.exec_params(sql_query, data)
  end
end

delete '/groceries/:id' do
  groceries_delete(params["id"])
  redirect "/"
end

get "/" do
  redirect "/groceries"
end

get "/groceries" do
  @groceries = groceries_all
  erb :groceries
end

post "/groceries" do
  groceries_save(params)
  redirect "/groceries"
end

get "/groceries/:id" do
  @groceries = groceries_find(params[:id])
  @comments = groceries_comments(params[:id]).to_a
  erb :show
end

get "/groceries/:id/edit" do
  @groceries = groceries_find(params[:id])
  erb :edit
end

patch "/groceries/:id/edit" do
  grocery_name = params["name"]
  unless grocery_name.strip.empty?
    groceries_update(params[:id], params[:name])
    redirect "/"
  end
  @groceries = groceries_find(params[:id])

  erb:edit
end
