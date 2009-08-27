require 'net/ftp'

class FTPStore
  class FileDoesNotExistError < RuntimeError; end
  
  def initialize
      raise Panda::ConfigError, "You must specify videos_domain, ftp_server and ftp_user to use ftp storage" unless Panda::Config[:videos_domain] && Panda::Config[:ftp_server] && Panda::Config[:ftp_user]
      open_connection
  end
  
  # Set file. Returns true if success.
  def set(key, tmp_file)
    ftp_login
    @ftp.put(tmp_file)
    @ftp.close
    
    true
  end
  
  # Get file. Raises FileDoesNotExistError if the file does not exist.
  def get(key, tmp_file)
    ftp_login
    @ftp.get(key, tmp_file)
    @ftp.close
    
    true
  end
  
  # Delete file. Returns true if success.
  # Raises FileDoesNotExistError if the file does not exist.
  def delete(key)
    ftp_login
    @ftp.delete(key)
    @ftp.close
    
    true
  end
  
  # Return the publically accessible URL for the given key
  def url(key)
    %(http://#{Panda::Config[:videos_domain]}/#{key})
  end
  
  private
  
  def raise_file_error(key)
    Merb.logger.error "Tried to delete #{key} but the file does not exist"
    raise FileDoesNotExistError, "#{key} does not exist"
  end
  
  def open_connection
    @ftp = Net::FTP.new(Panda::Config[:ftp_server])
  end
  
  def ftp_login
    @ftp.login(Panda::Config[:ftp_user], Panda::Config[:ftp_password])
    #Set to passive mode, EC2 was not being nice without this
    @ftp.sendcmd('passive')
  end
    
end
