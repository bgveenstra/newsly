class User < ActiveRecord::Base
	has_many :news, dependent: :destroy
	has_secure_password
   
  has_attached_file :avatar,
                   :styles => { :medium => "150x150>", :thumb => "44x44#>" },
                   :storage => :s3,
                   :s3_credentials => Proc.new { |a| a.instance.s3_credentials },
                   :path => "avatars/:id/:style/avatar.:extension",
                   :default_url => "https://s3.amazonaws.com/<<BUCKET>>/defaults/default_avatar.png"

  def s3_credentials
   { :bucket => ENV['S3_BUCKET'], :access_key_id => ENV['S3_PUBLIC_KEY'], :secret_access_key => ENV['S3_SECRET'] }
  end

   validates_attachment :avatar, :presence => true,
                        :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },
                        :size => { :in => 0..10.kilobytes }


  end
