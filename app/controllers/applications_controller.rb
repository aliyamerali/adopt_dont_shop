class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    if params[:commit] == "Submit Application"
      # @application.update(status: "Pending", description: params[:description])
      # @application.save
      if @application.update(status: "Pending", description: params[:description])
        @application.save
      else
        flash[:alert] = "Error: #{error_message(@application.errors)}"
        redirect_to "/applications/#{params[:id]}"
      end
    end

    if params[:search]
      @pets_search = Pet.search(params[:search])
    end

    if params[:adopt]
      pet = Pet.find(params[:adopt])
      @application.add_pet(pet)
    end

    @pets = @application.pets
  end

  def new
  end

  def create
    application = Application.new(application_params)

    if application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to '/applications/new'
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :description, :status)
  end
end
