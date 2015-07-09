class ServicesController < ApplicationController
  include ApplicationHelper
  # GET /services
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: ServicesDatatable.new(view_context) }
      #format.xls { send_data @services.to_csv(col_sep: "\t") }
      format.csv { render text: ServicesDatatable.new(view_context).as_csv }
    end
  end

  def upsert_form
    if /^[0-9]*$/.match(params[:service_id])
      @service = Service.find(params[:service_id])
      @service['budget'] = ApplicationHelper.comma_numbers(@service['budget'], '')
      @project = @service.project
      @project['budget'] = ApplicationHelper.comma_numbers(@project['budget'], '')
      @show_resetter = false
    else
      @service = Service.new 
      @project = Project.new
      @show_resetter = true
    end
    
    render :layout => false
  end

  # GET /services/1
  # GET /services/1.json
  def show
    @service = Service.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @service }
    end
  end

  # GET /services/new
  # GET /services/new.json
  def new
    @service = Service.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id])
  end

  # POST /services
  # POST /services.json
  def create
    params[:service][:created_by] = @current_user.id
    params[:service][:budget] = ApplicationHelper.ensure_float params[:service][:budget]    
    @service = Service.new(params[:service])
    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
        format.json { render json: @service.to_json, status: :created, location: @service }
      else
        format.html { render action: "new" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.json
  def update
    @service = Service.find(params[:id])
    params[:service][:created_by] = @current_user.id
    params[:service][:budget] = ApplicationHelper.ensure_float params[:service][:budget]    
    respond_to do |format|
      if @service.update_attributes(params[:service])
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { render json: @service.to_json }
      else
        format.html { render action: "edit" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    bonus = Bonus.find_by_service_id(params[:id])
    if bonus
      bonus.delete
    end
    @service = Service.find(params[:id])
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url }
      format.json { render json: @service.id}
    end
  end
end
