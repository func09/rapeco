# Initialize with:
#   rake backup:run trigger='mysql-backup-s3'
backup 'mysql-backup-s3' do
  
  adapter :mysql do
    user        'root'
    password    ''
    database    'bimitter_production'
  
    # skip_tables ['table1', 'table2', 'table3']
    # 
    # options do
    #   host    '123.45.678.90'
    #   port    '80'
    #   socket  '/tmp/socket.sock'
    # end
  end
  
  storage :s3 do
    access_key_id     ENV['S3_ACCESS_KEY_ID']
    secret_access_key ENV['S3_SECRET_ACCESS_KEY']
    bucket            '/rapeco/backups/db/'
    use_ssl           true
  end
  
  keep_backups 365
  encrypt_with_password ENV['BACKUP_ENCRYPT_PASSWORD']
  
end
