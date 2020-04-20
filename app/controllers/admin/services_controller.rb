class Admin::ServicesController < Admin::BaseController
  before_action :set_service, only: [:show, :update, :destroy]

  def index
    if params[:query].present?
      @services = Service.search(params[:query]).page(params[:page])
    else
      @services = Service.kept.newest # default sort
      @services = Service.alphabetical if params[:order] === "asc" && params[:order_by] === "name"
      @services = Service.reverse_alphabetical if params[:order] === "desc" && params[:order_by] === "name"
      @services = Service.oldest if params[:order] === "asc" && params[:order_by] === "updated_at"
      @services = @services.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.csv { send_data Service.all.to_csv }
    end
  end

  def show
    @notes = @service.notes.all
    @note = @service.notes.new

    @watched = current_user.watches.where(service_id: @service.id).exists?
    if @service.versions.length > 4
      @versions = @service.versions.last(3).reverse
      @versions.push(@service.versions.first)
    else
      @versions = @service.versions.reverse
    end      

  end

  def update
    if @service.update(service_params)
      redirect_to admin_service_url(@service), notice: "Service has been updated"
    else
      render "show"
    end
  end
  
  def new
    @service = Service.new
  end

  def create
    @service = Service.create(service_params)
    if @service.save
      redirect_to admin_service_url(@service), notice: "Service has been created."
    else
      render "new"
    end
  end

  def destroy
    @service.archive
    redirect_to admin_service_url(@service)
  end
  
  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(
      :name,
      :organisation_id,
      :description,
      :url,
      :email,
      taxonomy_ids: [],
      location_ids: []
    )
  end

end