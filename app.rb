require 'sinatra'
require 'pg'
require 'pony'

db_params = {
	host: 'minedmindsmailinglist1.cff8qqhpkday.us-west-2.rds.amazonaws.com',
	port: '5432',
	dbname: 'mailinglist',
	user: 'mailinglist',
	password: 'mailinglist123'
}

db = PG::Connection.new(db_params)

get '/' do
	erb :index, :locals => {:message => ""}
end	

post '/input' do
	user_email = params[:user_email]
	db.exec("INSERT INTO subscribers (email) VALUES ('#{user_email}');")

	erb :index, :locals => {:message => 'Thank you for subscribing'}
end


get '/admin_email' do
	erb :subscribers, :locals => {}
end	

post '/contact-form' do
  subject = params[:subject]
  subscribers = db.exec("SELECT email FROM subscribers;")
  message = params[:message]
subscribers. each do |email|
	emails = email["email"] 
 

    Pony.mail(
        :to => "#{emails}", 
        :from => 'info@minedminds.org',
        :subject => "#{subject}", 
        :content_type => 'text/html', 
        :body => erb(:email2,:layout=>false),
        :via => :smtp, 
        :via_options => {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
           :user_name           => 'joseph.mckenzie@minedminds.org',
           :password            => 'Bubbadog420',
           :authentication       => :plain, 
           :domain               => "localhost" 
        }
      )
end
  erb :subscribers, :locals => {:subscribers => subscribers}
end 





