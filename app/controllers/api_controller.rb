class ApiController < ApplicationController

  before_action :authenticate_user!, except: [:messy]
  acts_as_token_authentication_handler_for User, except: [:messy]
  respond_to :json

  def messy

    @final_number = [10,5,20]
    @h = Hash.new{ |h,v| h[v] = [] }
    @z = {}
    num = rand 5 .. 20

    num.times do

      complicated_data = SecureRandom.hex
      random_words = ['hey', 'this', 'simple', 'germany', 'munich', 'hello'].sample
      @h[random_words.to_sym] = complicated_data

    end

    @h.each do |key,sub|

      n = [*1..35].sample

      if [*1..18].include? n

        g = [0,1].sample

        if g == 0
          @z[key] = fill_num
        else
          @z[key] = [fill_num]
        end

      elsif n == 35

        raise ActionController::RoutingError.new('Not Found')

      else

        @z[key] = sub

      end


    end

    render :json => @z

  end

  def fill_num

    h = {}
    a = (1..10).to_a
    r = rand 1..10

    o = rand 0..2

    r.times do |i|

      h[(i+1).to_s] = a.delete_at(Random.rand(a.size))

      unless @final_number.empty?
        if o == 0

        g = [0,1].sample

        if g == 0
          @z[@final_number.first] = @final_number.first * 10
        else
          @z[@final_number.first] = [@final_number.first * 10]
        end

        @final_number.shift
        end
      end

    end

  end


end