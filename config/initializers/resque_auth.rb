Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == "WinterIsComming1991"
end
