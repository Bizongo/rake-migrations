module RakeMigrations
  class Config
    attr_accessor :database_name, :hostname, :username, :password

    def initialize
      @database_name = nil
      @hostname = nil
      @username = nil
      @password = nil
    end

    def generate_database_client
      validate_presence_of_required_connection_attributes
      log_presence_of_optional_connection_attributes
      connection_object_based_on_attributes
    end

    private

    def validate_presence_of_required_connection_attributes
      fail 'Database name should be provided!' unless @database_name
      fail 'Host Name should be provided' unless @hostname
      true
    end

    def log_presence_of_optional_connection_attributes
      p 'Connecting to the database without username' unless @username
      p 'Connecting to the database without password' unless @password
    end

    def connection_object_based_on_attributes
      if @password.present? && @username.present?
        client = PG.connect(host: @hostname,
                            dbname: @database_name,
                            user: @username,
                            password: @password)
      else
        client = PG.connect(host: @hostname,
                            dbname: @database_name)
      end
      client
    end

  end
end