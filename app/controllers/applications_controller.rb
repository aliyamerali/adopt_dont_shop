class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    if params[:commit] == "Submit Application"
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

  def admin_show
    @application = Application.find(params[:id])
    @apps_pets = ApplicationsPet.joins(:pet).where(application_id: @application.id)

    if @apps_pets.where("status = ?" , 'approved').count == @apps_pets.count
      @application.update(status: "Approved")
      @apps_pets.each do |apps_pet|
        apps_pet.pet.update(adoptable: false)
      end
    elsif @apps_pets.where("status = ? or status = ?",'approved','rejected').count == @apps_pets.count
      @application.update(status: "Rejected")
    end

  end

  def admin_update
    @join_record = ApplicationsPet.where(pet_id: params[:pet], application_id: params[:id])
    @join_record.update(status: params[:status])

    redirect_to "/admin/applications/#{params[:id]}"
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :description, :status)
  end
end
