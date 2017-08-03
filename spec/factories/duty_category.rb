FactoryGirl.define do

  factory :duty_health_category, class: DutyCategory do
    code                'L1-84'
    name_translations   { { :en => 'Health & Beauty', :'zh-CN' => '美容 & 护理', :de => 'Gesundheit & Pflege' } }

    after(:create) do |health_category|
      create_list(:duty_medicine_category, 1, parent: health_category)
    end
  end

  factory :duty_medicine_category, class: DutyCategory do
    code              'L2-276'
    name_translations { { :en => 'Medicine & Vitamins', :'zh-CN' => '药品和保健品', :de => 'Medikament & Nahrungsergänzung' } }
  end

end
