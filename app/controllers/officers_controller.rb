class OfficersController < ApplicationController
  before_action :set_officer, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @active_officers = Officer.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_officers = Officer.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
    @current_assignments = @officer.assignments.current.chronological
    @past_assignments = @officer.assignments.past.chronological
  end

  def new
    @officer = Officer.new
  end

  def edit
  end

  def create
    @officer = Officer.new(officer_params)
    @user.active = true
    if @officer.save
      flash[:notice] = "Successfully created #{@officer.proper_name}."
      redirect_to officer_path(@officer) 
    else
      render action: 'new'
    end      
  end

  def update
    respond_to do |format|
      if @officer.update_attributes(officer_params)
        format.html { redirect_to @officer, notice: "Updated all information" }
        
      else
        format.html { render :action => "edit" }
        
      end
    end
  end





  private
  # Use callbacks to share common setup or constraints between actions.
  def set_officer
    @officer = Officer.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def officer_params
    params.require(:officer).permit(:first_name, :last_name, :rank, :ssn, :active, :unit_id)
  end


end
