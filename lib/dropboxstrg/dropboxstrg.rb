require 'cloudstrg/cloudstrg'

class DropboxStrg < CloudStrg::CloudStorage
  require 'dropbox_sdk'
  
  APP_KEY = 'ebwn2abt7mznz56'
  APP_SECRET = 'g03si51tws05re3'
  ACCESS_TYPE = :app_folder 

  mattr_accessor :session, :client, :user, :redirect_path
  @session = nil
  @client = nil
  @user = nil
  @redirect_path = nil

  def initialize params
    @session = DropboxSession.new(APP_KEY, APP_SECRET)
  end

  def config params
    @redirect_path = params[:redirect]
    @user = params[:user]
    user_params = @user.dropboxstrgparams
    if not user_params
      user_params = @user.build_dropboxstrgparams
    end

    session = params[:session]
    
    if session[:dropbox_rkey] and session[:dropbox_rsecret]
      begin
        @session.set_request_token(session[:dropbox_rkey], session[:dropbox_rsecret])
        @session.get_access_token()
        user_params.akey = @session.access_token.key
        user_params.asecret = @session.access_token.secret
        session[:dropbox_rkey] = nil
        session[:dropbox_rsecret] = nil
        user_params.save()
      rescue DropboxAuthError
        @session = DropboxSession.new(APP_KEY, APP_SECRET)
        user_params.akey = nil
        user_params.asecret = nil
        session[:dropbox_rkey] = nil
        session[:dropbox_rsecret] = nil
        user_params.save()
        params[:session] = session
        return config params
      end
    else
      @session.get_request_token()    

      if user_params.akey and user_params.asecret
        @session.set_access_token(user_params.akey, user_params.asecret)
      else
        session[:dropbox_rkey] = @session.request_token.key
        session[:dropbox_rsecret] = @session.request_token.secret
        session[:plugin_name] = self.class.to_s.split('Strg')[0].downcase
        return session, @session.get_authorize_url(callback=@redirect_path)
      end
    end
    @client = DropboxClient.new(@session, ACCESS_TYPE)
    return session, false
  end

  def create_file params
    if not @client
      return false
    end
    filename = params[:filename]

    @client.put_file("/#{filename}", params[:file_content])
    
    file_id = save_remoteobject(@user, filename, params[:file_content], filename)
    return file_id
  end

  #def create_folder params
  #  if not @client
  #    return false
  #  end
  #  @client.file_create_folder("/#{@username}")
  #end

  def get_file params
    if not @client
      return false
    end
    filename = params[:fileid]
    return filename, filename, @client.get_file("/#{filename}")
  end

  def update_file params
    if not @client
      return false
    end
    filename = params[:fileid]

    @client.put_file("/#{filename}", params[:file_content], overwrite=true)

    return save_remoteobject(@user, filename, params[:file_content], filename)
  end

  def remove_file params
    if not @client
      return false
    end
    filename = params[:fileid]
    @client.file_delete("/#{filename}")
  end

  def list_files
    if not @client
      return false
    end
    data = @client.metadata("/")
    lines = []
    data["contents"].each do |line|
      lines.append([line["path"].split("/")[-1],line["path"].split("/")[-1]])
    end
    return lines
  end

end
