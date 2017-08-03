FactoryGirl.define do

  factory :category, class: Category do

    status true
    position { Helpers::Global.next_number(:category) }
    slug 'food'
    name_translations { { :'zh-CN' => 'Food', :de => 'Food' } }
    desc { { :'zh-CN' => 'Food Description', :de => 'Food Description' } }

  end

end
