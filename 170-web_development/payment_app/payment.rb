require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do 
  session[:payments] ||= []
end

def format_missing_value(missing_value)
  message = ""
  missing_value.each_with_index do |name, index|
    if (index + 1) == missing_value.size
      message << name.to_s + "."
    elsif (index + 2) == missing_value.size
      message << (name.to_s + " and ") 
    else
      message << (name.to_s + ", ")
    end
  end
  "Missing value in #{message}"
end

get "/" do
  redirect "/payments"
end

get "/payments" do 
  erb :payments
end

get "/payments/create" do
  erb :create
end

post "/payments/create" do
  missing_value = [ :first_name, :last_name, :card_number, 
    :expiration_date, :ccv ].select { |name| params[name].strip.empty? }

  if !missing_value.empty?
    session[:message] = format_missing_value(missing_value)
    erb :create
  elsif params[:card_number].size != 16
    session[:message] = "Invalid card number. Card number must be 16 characters long."
    erb :create
  else
    session[:payments] << { full_name: (params[:first_name] + " " + params[:last_name]), 
      card_number: params[:card_number], expiration_date: params[:expiration_date],
      ccv: params[:ccv], time: Time.now}
    session[:message] = "Thank you for your payment."
    redirect "payments"
  end
end