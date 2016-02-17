json.array!(@collections) do |c|
  if c.user
    json.id c.id
    json.name c.name
    json.desc c.desc
    json.products_imgs c.products.map { |p| p.img0.url ? request.base_url + p.img0.url : nil }.compact
    json.set! :owner_id, c.user.id
    json.set! :owner_name, c.user.username
    json.set! :owner_img, c.user.pic.url
  end
end
