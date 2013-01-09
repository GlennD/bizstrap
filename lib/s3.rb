require 'aws-sdk'

module S3
  class << self
    def upload(filepath, s3bucket, s3path, content_type)
      s3 = AWS::S3.new
      b  = s3.buckets[s3bucket]
      o  = b.objects[s3path]

      o.write(:file => filepath, 
              :acl => :public_read, 
              :content_type => content_type)
      o
    end
  end
end
