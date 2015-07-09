class BonusSchemesController < ApplicationController

  before_filter :admin_only
  
  def index
    @bonus_schemes = BonusScheme.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bonus_schemes }
    end
  end

  # GET /bonus_schemes/1
  # GET /bonus_schemes/1.json
  def show
    @bonus_scheme = BonusScheme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bonus_scheme }
    end
  end

  # GET /bonus_schemes/new
  # GET /bonus_schemes/new.json
  def new
    @bonus_scheme = BonusScheme.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bonus_scheme }
    end
  end

  # GET /bonus_schemes/1/edit
  def edit
    @bonus_scheme = BonusScheme.find(params[:id])
  end

  # POST /bonus_schemes
  # POST /bonus_schemes.json
  def create
    @bonus_scheme = BonusScheme.new(params[:bonus_scheme])

    respond_to do |format|
      if @bonus_scheme.save
        format.html { redirect_to @bonus_scheme, notice: 'Bonus scheme was successfully created.' }
        format.json { render json: @bonus_scheme, status: :created, location: @bonus_scheme }
      else
        format.html { render action: "new" }
        format.json { render json: @bonus_scheme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bonus_schemes/1
  # PUT /bonus_schemes/1.json
  def update
    @bonus_scheme = BonusScheme.find(params[:id])

    respond_to do |format|
      if @bonus_scheme.update_attributes(params[:bonus_scheme])
        format.html { redirect_to @bonus_scheme, notice: 'Bonus scheme was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bonus_scheme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bonus_schemes/1
  # DELETE /bonus_schemes/1.json
  def destroy
    @bonus_scheme = BonusScheme.find(params[:id])
    @bonus_scheme.destroy

    respond_to do |format|
      format.html { redirect_to bonus_schemes_url }
      format.json { head :no_content }
    end
  end
end
