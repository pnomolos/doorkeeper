module Doorkeeper
  class ApplicationsController < Doorkeeper::ApplicationController
    respond_to :html

    before_filter :authenticate_admin!

    def index
      @applications = Application.all
    end

    def new
      @application = Application.new
    end

    def create
      @application = Application.new(params[:application])
      if @application.save
        flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :create])
        respond_with [:oauth, @application]
      else
        render :new
      end
    end

    def show
      @application = find_resource(params[:id])
    end

    def edit
      @application = find_resource(params[:id])
    end

    def update
      @application = find_resource(params[:id])
      if update_attributes(@application, params[:application])
        flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :update])
        respond_with [:oauth, @application]
      else
        render :edit
      end
    end

    def destroy
      @application = find_resource(params[:id])
      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :destroy]) if @application.destroy
      redirect_to oauth_applications_url
    end
    
    private
    def find_resource(id)
      Application.find(id)
    end
    
    def update_attributes(model, attributes)
      model.update_attributes(attributes)
    end
  end
end

if :data_mapper == Doorkeeper.configuration.orm_name
  module Doorkeeper
    class ApplicationsController
      private
      def find_resource(id)
        Application.get(id)
      end
      
      def update_attributes(model, attributes)
        model.update(attributes)
      end
    end
  end
end