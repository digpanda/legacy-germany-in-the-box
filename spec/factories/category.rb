FactoryGirl.define do

  factory :category, class: Category do

    status true
    position { Helpers::Global.next_number(:category) }
    name_translations { {:'zh-CN' => 'Category 1', :de => 'Category 1'} }
    desc { {:'zh-CN' => 'Category Description 1', :de => 'Category Description 1'} }

  end

end
