require 'net/sftp'

class SFTPStore
  class FileDoesNotExistError < RuntimeError; end
  
  def initialize
      raise Panda::ConfigError, "You must specify videos_domain, sftp_server and sftp_user to use sftp storage" unless Panda::Config[:videos_domain] && Panda::Config[:sftp_server] && Panda::Config[:sftp_user]      
      @sftp = NET::SFTP.start(Panda::Config[:sftp_server], Panda::Config[:sftp_user], Panda::Config[:sftp_password])
  end
  
  # Set file. Returns true if success.
  def set(key, tmp_file)
    @sftp.upload(tmp_file, key)
  end
  
  # Get file. Raises FileDoesNotExistError if the file does not exist.
  def get(key, tmp_file)
    @sftp.download(key, tmp_file)
  end
  
  # Delete file. Returns true if success.
  # Raises FileDoesNotExistError if the file does not exist.
  def delete(key)
    raise "Method not implemented. Called abstract class."
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
end
