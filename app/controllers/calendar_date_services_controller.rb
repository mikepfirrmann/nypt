class CalendarDateServicesController < ApplicationController
  # GET /calendar_date_services
  # GET /calendar_date_services.json
  def index
    @calendar_date_services = CalendarDateService.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @calendar_date_services }
    end
  end

  # GET /calendar_date_services/1
  # GET /calendar_date_services/1.json
  def show
    @calendar_date_service = CalendarDateService.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @calendar_date_service }
    end
  end

  # GET /calendar_date_services/new
  # GET /calendar_date_services/new.json
  def new
    @calendar_date_service = CalendarDateService.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @calendar_date_service }
    end
  end

  # GET /calendar_date_services/1/edit
  def edit
    @calendar_date_service = CalendarDateService.find(params[:id])
  end

  # POST /calendar_date_services
  # POST /calendar_date_services.json
  def create
    @calendar_date_service = CalendarDateService.new(params[:calendar_date_service])

    respond_to do |format|
      if @calendar_date_service.save
        format.html { redirect_to @calendar_date_service, notice: 'Calendar date service was successfully created.' }
        format.json { render json: @calendar_date_service, status: :created, location: @calendar_date_service }
      else
        format.html { render action: "new" }
        format.json { render json: @calendar_date_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /calendar_date_services/1
  # PUT /calendar_date_services/1.json
  def update
    @calendar_date_service = CalendarDateService.find(params[:id])

    respond_to do |format|
      if @calendar_date_service.update_attributes(params[:calendar_date_service])
        format.html { redirect_to @calendar_date_service, notice: 'Calendar date service was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @calendar_date_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendar_date_services/1
  # DELETE /calendar_date_services/1.json
  def destroy
    @calendar_date_service = CalendarDateService.find(params[:id])
    @calendar_date_service.destroy

    respond_to do |format|
      format.html { redirect_to calendar_date_services_url }
      format.json { head :ok }
    end
  end
end
