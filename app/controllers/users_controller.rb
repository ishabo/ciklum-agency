require 'json'
class UsersController < ApplicationController
  before_filter :admin_only
  # GET /users
  # GET /users.json
  include SecurityHelper
  def index
    @users = User.joins('LEFT JOIN positions p ON p.id = position_id').all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
  	@user_data = processData()
  	@user = User.new(@user_data)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user_data = processData()
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(@user_data)
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def processData
  	user_data = params[:user]
  	if user_data[:password].to_s.strip.length > 0
    else
    	user_data.delete :password
    end
    return user_data
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end


end
