FactoryGirl.define do
  sequence :plate do |n|
    n.to_s.rjust(3, "0") + 'aaa'
  end
  
  sequence :email do |n|
    "email-#{n}@example.com"
  end

  sequence :phone do |n|
    n.to_s.ljust(10, "0")
  end

  factory :user do
    plate
    
    factory :user_email do
      via 'EMAIL'
      destination { generate(:email) }

      factory :user_email_default_settings do
        after(:create) do |user|
          create(:setting_verificacion, user: user)
          create(:setting_adeudos, user: user)
          create(:setting_no_circula_weekend, user: user)
        end
      end
    end

    factory :user_phone do
      via 'PHONE'
      destination { generate(:phone) }
    end
  end

  factory :setting do
    user { create(:user_email) }
    
    factory :setting_verificacion do
      setting 'VERIFICACION'
    end
    
    factory :setting_adeudos do
      setting 'ADEUDOS'
    end
    
    factory :setting_no_circula_weekday do
      setting 'NO_CIRCULA_WEEKDAY'
    end
    
    factory :setting_no_circula_weekend do
      setting 'NO_CIRCULA_WEEKEND'
    end
  end

  factory :delegacion do
    url 'example-borough'
    name 'Example Borough'
  end

  factory :verificentro do
    delegacion
    sequence(:number) { |n| n.to_s.rjust(4, "0") }
    name 'Example Inc'
    address 'Fake street 123'
    phone
    lat 19.43
    lon -99.14
  end

end
