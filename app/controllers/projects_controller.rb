class ProjectsController < ApplicationController
  include ApplicationHelper  
  #before_filter :admin_only
  # GET /projects
  def index
    if params[:search]
      @projects = Project.where("name LIKE :search OR client LIKE :search ", search: "%#{params[:search]}%")
    else
      @projects = Project.all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects.to_json }
    end
  end

  # GET /projects/1
  def show
    @project = Project.find(params[:id])
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  def create
    params[:project][:budget] = ApplicationHelper.ensure_float params[:project][:budget]
    @project = Project.new(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end    
  end

  # PUT /projects/1
  def update
    @project = Project.find(params[:id])
    params[:project][:budget] = ApplicationHelper.ensure_float params[:project][:budget]
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Projects was successfully updated.' }
        format.json { render json: @project.to_json }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_url
  end
end
