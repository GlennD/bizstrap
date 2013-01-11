require 'aws-sdk'
require 'colorize'

module S3
  class << self
    def upload_dir(directory, s3bucket, s3path)
      Dir.glob("#{directory}/**/*").each do |f| 
        next if File.directory?(f)
        relative_path = f[directory.length..f.length]
        s3_file = "#{s3path}#{relative_path}"
        upload f, s3bucket, s3_file, detect_content_type(f)
        puts "Uploaded #{s3_file}"
      end
    end

    def upload(filepath, s3bucket, s3path, content_type)
      s3 = AWS::S3.new
      b  = s3.buckets[s3bucket]
      o  = b.objects[s3path]

      o.write(:file => filepath, 
              :acl => :public_read, 
              :content_type => content_type)
      o
    end

    private
    def detect_content_type(file)
      case File.extname(file)
      when  ".html"
        "text/html"
      when ".css"
        "text/css"
      when ".js"
        "application/javascript"
      when ".jpg"
        "image/jpeg"
      when ".png"
        "image/png"
      else 
        ""
      end
    end
  end
end
