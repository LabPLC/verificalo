FactoryGirl.define do
  sequence :plate, 1 do |n|
    n.to_s.ljust(3, '0') + 'aaa'
  end
  
  sequence :email do |n|
    "email-#{n}@example.com"
  end

  sequence :phone do |n|
    n.to_s.ljust(10, '0')
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
    sequence(:url) { |n| "example-borough-#{n}" }
    sequence(:name) { |n| "Example Borough #{n}" }

    factory :delegacion_verificentros do
      ignore do
        verificentros_count 3
      end
      after(:create) do |delegacion, evaluator|
        create_list(:verificentro, 
                    evaluator.verificentros_count,
                    delegacion: delegacion)
      end
    end
  end
  
  factory :verificentro do
    delegacion
    sequence(:number) { |n| n.to_s.rjust(4, '0') }
    sequence(:name) { |n| "Example #{n} Inc" }
    address 'Fake street 123'
    phone
    lat 19.43
    lon -99.14
  end

end
