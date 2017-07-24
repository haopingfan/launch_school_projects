require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do 
  session[:money] ||= 100
end

get "/" do
  redirect "/bet"
end

get "/bet" do
  erb :bet
end

get "/broke" do
  erb :broke
end

post "/bet" do 
  bet_money = params[:bet].to_i

  if bet_money > session[:money] || bet_money < 1 
    session[:message] = "Bets must be between $1 and $#{session[:money]}."
    redirect "/bet"
  end

  random_num = rand(1..3)
  user_guess = params[:guess].to_i
  
  if user_guess == random_num
    session[:money] += bet_money
    session[:message] = "You have guessed correctly."
  else
    session[:money] -= bet_money
    session[:message] = "You guessed #{user_guess}, but the number was #{random_num}."
  end

  if session[:money] <= 0
    redirect "/broke"
  else    
    redirect "/bet"
  end
end

post "/withdraw" do 
  session[:money] = 100
  session[:message] = "Welcome Back!"
  redirect "/bet"
end
