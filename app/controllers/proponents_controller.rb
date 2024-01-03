# frozen_string_literal: true

# app/controllers/proponents_controller.rb

class ProponentsController < ApplicationController
  before_action :set_proponent, only: [:edit, :update, :destroy]

  def index
    query = current_user.proponents.order(name: :asc)
    @proponents = if params[:search].present?
      Kaminari.paginate_array(query.search(params[:search])).page(params[:page]).per(5)
    else
      query.page(params[:page]).per(5)
    end
  end

  def new
    @proponent = Proponent.new.decorate
  end

  def create
    salary = params[:proponent][:salary].delete(".").tr(",", ".")
    discount = params[:proponent][:inss_discount]&.delete(".")&.tr(",", ".")
    @proponent = Proponent.new(proponent_params.merge(salary: salary, inss_discount: discount))
    @proponent.user = current_user

    respond_to do |format|
      if @proponent.save
        format.html do
          redirect_to(
            proponents_path,
            notice: t("flash.actions.create.notice", resource_name: Proponent.model_name.human),
          )
        end
        format.turbo_stream do
          flash.now[:notice] = t("flash.actions.create.notice", resource_name: Proponent.model_name.human)
        end
      else
        render(:new, status: :unprocessable_entity)
      end
    end
  end

  def edit
  end

  def update
    salary = params[:proponent][:salary].delete(".").tr(",", ".")
    discount = params[:proponent][:inss_discount]&.delete(".")&.tr(",", ".")
    respond_to do |format|
      if @proponent.update(proponent_params.merge(salary: salary, inss_discount: discount))
        format.html do
          redirect_to(
            proponents_path,
            notice: t("flash.actions.update.notice", resource_name: Proponent.model_name.human),
          )
        end
        format.turbo_stream do
          flash.now[:notice] = t("flash.actions.update.notice", resource_name: Proponent.model_name.human)
        end
      else
        render(:edit, status: :unprocessable_entity)
      end
    end
  end

  def destroy
    @proponent.destroy

    respond_to do |format|
      format.html do
        redirect_to(
          proponents_path,
          notice: t("flash.actions.destroy.notice", resource_name: Proponent.model_name.human),
        )
      end
      format.turbo_stream do
        flash.now[:notice] = t("flash.actions.destroy.notice", resource_name: Proponent.model_name.human)
      end
    end
  end

  def report_data
    render(json: {
      labels: [
        "Até R$ 1.045,00",
        "De R$ 1.045,01 a R$ 2.089,60",
        "De R$ 2.089,61 até R$ 3.134,40",
        "De R$ 3.134,41 até R$ 6.101,06",
      ],
      values: Proponent.data_for_chart,
    })
  end

  def report
    @labels = [
      "Até R$ 1.045,00",
      "De R$ 1.045,01 a R$ 2.089,60",
      "De R$ 2.089,61 até R$ 3.134,40",
      "De R$ 3.134,41 até R$ 6.101,06",
    ]
    @values = Proponent.data_for_chart
  end

  def calculate_inss_discount
    CalculateDiscountJob.perform_async(params[:salary])

    render(json: {
      message: "Calculando desconto em segundo plano...",
    })
  end

  private

  def set_proponent
    @proponent = Proponent.find(params[:id]).decorate
  end

  def proponent_params
    params.require(:proponent).permit(
      :name,
      :cpf,
      :birth_date,
      :residential_phone,
      :mobile_phone,
      :inss_discount,
      addresses_attributes: [:id, :street, :number, :neighborhood, :city, :state, :zip_code, :_destroy],
    )
  end
end
