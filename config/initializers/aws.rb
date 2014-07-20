access_key = ENV['AWS_ACCESS_KEY']
secret_key = ENV['AWS_SECRET_KEY']

AWS.config(access_key_id: access_key, secret_access_key: secret_key)