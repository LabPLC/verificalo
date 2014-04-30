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
    end

    factory :user_phone do
      via 'PHONE'
      destination { generate(:phone) }
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
