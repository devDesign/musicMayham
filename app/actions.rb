# Homepage (Root path)
enable :sessions
 
helpers do
  
def login?
    if session[:username].nil?
      return false
    else
      return true
    end
  end
  
  def username
    return session[:username]
  end

end

get '/users/signup' do
  erb :"/users/signup"
end

post "/users/signup" do
  @password_salt = BCrypt::Engine.generate_salt
  @password_hash = BCrypt::Engine.hash_secret(params[:password], @password_salt)
  
  #ideally this would be saved into a database, hash used just for sample
  @user = User.new(
    username: params[:username],
    salt: @password_salt,
    passwordhash: @password_hash 
  )
  if @user.save
    session[:username] = params[:username]
    session[:id] = @user.id
    redirect "/users"
  else
  redirect "/music_videos/"
  end
end
 
post "/users/login" do
    @user = User.find_by(username: params[:username])
    if @user.passwordhash == BCrypt::Engine.hash_secret(params[:password], @user[:salt])
      session[:username] = params[:username]
      session[:id] = @user.id
      redirect "/users"
    end
end
 
get "/users/logout" do
  session[:username] = nil
  session[:id] = nil
  redirect "/"
end

get '/users' do
  @music_videos = MusicVideo.all
  erb :'users/index'
end

get '/' do
  MusicVideo.all
  erb :index
end

get '/music_videos' do
  @downvotes = Downvote.all
  @upvotes = Upvote.all
  @music_videos = MusicVideo.all
  @music_videos.each do |music_video|
    upvote = @upvotes.where(:music_video_id => music_video.id).count
    downvote = @downvotes.where(:music_video_id => music_video.id).count
    music_video.total_upvotes = upvote
    music_video.total_downvotes = downvote
    music_video.save
  end
  @music_videos_sorted = MusicVideo.order(total_upvotes: :desc)
  erb :'music_videos/index'
end

get '/music_videos/new' do
  erb :'music_videos/new'
end

get '/music_videos/:id' do
  @music_video = MusicVideo.find params[:id]
  erb :'music_videos/show'
end

post '/music_videos' do
  document = Nokogiri::HTML(open(params[:url]), nil, 'UTF-8')

  @youtube = params[:url]
  @youtube = @youtube.scan(/\w{11}$/)
  @music_videos = MusicVideo.new(
    title: document.at('title').text.gsub(/- YouTube/,""),
    url: @youtube.join(""),
    user_name:  params[:user_name],
    user_id: session[:id]
  )
  if @music_videos.save
    redirect '/music_videos'
  else
    erb :'music_videos/new'
  end
end

post '/upvote' do
    if login?
      @vote_song = Upvote.new(
      music_video_id: params[:work],
      user_id: session[:id]
      )
      if @vote_song.save
        redirect '/music_videos'
      else
        redirect '/music_videos'
      end
    end
  end


post '/downvote' do
      @downvote_song = Downvote.new(
      music_video_id: params[:downvote],
      user_id: session[:id]
      )
      if @downvote_song.save
        redirect '/music_videos'
      else
        redirect '/music_videos'
      end
  end

