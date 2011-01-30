# Initialize with:
#   rake backup:run trigger='mysql-backup-s3'
backup 'mysql-backup-s3' do

  adapter :mysql do
    user        'root'
    password    ''
    database    'bimitter_production'
  end

  storage :s3 do
    access_key_id     ENV['S3_ACCESS_KEY_ID']
    secret_access_key ENV['S3_SECRET_ACCESS_KEY']
    bucket            'rapeco.jp/backup'
    use_ssl           true
  end
  
  # keep_backups 365
  
end

