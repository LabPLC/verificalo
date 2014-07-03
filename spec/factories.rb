FactoryGirl.define do
  sequence :plate, 1 do |n|
    n.to_s.ljust(3, '0') + 'ABC'
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
    sequence(:url) { |n| "borough-#{n}" }
    sequence(:name) { |n| "Borough #{n}" }

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
    sequence(:name) { |n| "Verificentro #{n} Inc" }
    address 'Fake Street 123'
    phone
    lat 19.43
    lon -99.14
  end

  factory :category do
    sequence(:url) { |n| "category-#{n}" }
    sequence(:name) { |n| "Category #{n}" }

    factory :category_answers do
      ignore do
        answers_count 3
      end
      after(:create) do |category, evaluator|
        create_list(:answer, 
                    evaluator.answers_count,
                    category: category)
      end
    end
  end

  factory :contact do
    sequence(:name) { |n| "Contact #{n}" }
    phone '1234 5678'
    phone_schedule 'Lun a Vie de 10 a 5'
    email 'info@example.com'
    address 'Fake street 123'
    address_schedule 'Lun a Vie de 9 a 6'
    lat 19.43
    lon -99.14
  end

  factory :answer do
    category
    contact
    sequence(:url) { |n| "answer-#{n}" }
    sequence(:title) { |n| "Question #{n}" }
    sequence(:body) { |n| "Answer #{n}" }
    sequence(:source) { |n| "source-#{n}" }
  end
end
