class HomeController < ApplicationController
  def index
  end

  def sign_in
    session[:user_id] = if Rails.env.development?
      case DOORKEEPER_ORM
        when :data_mapper
          res = User.first || User.create({:name => "Joe", :password => "sekret"})
          res && res.id
        else :create!
          User.first || User.create!({:name => "Joe", :password => "sekret"})
      end
    else
      res = User.first
      if :data_mapper == DOORKEEPER_ORM
        res && res.id
      else
        res
      end
    end
    redirect_to '/'
  end

  def callback
    render :text => "ok"
  end
end
