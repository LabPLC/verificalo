FactoryGirl.define do
  sequence :plate, 1 do |n|
    n.to_s.ljust(3, '0') + 'aaa'
  end
  
  sequence :address do |n|
    "email-#{n}@example.com"
  end

  sequence :number do |n|
    n.to_s.ljust(10, '0')
  end

  factory :user do
    plate
    adeudos true
    verificacion true
    no_circula_weekend true    
  end

  factory :email do
    user
    address
  end

  factory :phone do
    user
    number
    cellphone true
    morning true
    afternoon true
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
