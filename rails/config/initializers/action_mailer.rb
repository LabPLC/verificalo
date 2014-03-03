# http://justinreid.com/configure-actionmailer-to-use-multiple-smtp-settings/

module ActionMailer
  class Base
    cattr_accessor :smtp_config

    self.smtp_config = YAML::load(File.open("#{Rails.root}/config/smtp.yml"))[Rails.env]

    def self.smtp_settings
      @@smtp_settings = self.smtp_config.symbolize_keys
    end
    
  end
end
