# frozen_string_literal: true

# app/controllers/proponents_controller.rb

class ProponentsController < ApplicationController
  before_action :set_proponent, only: [:edit, :update, :destroy]

  def index
    @proponents = Proponent.page(params[:page]).per(5)
  end

  def new
    @proponent = Proponent.new
  end

  def create
    salary = params[:proponent][:salary].delete(".").tr(",", ".")
    @proponent = Proponent.new(proponent_params.merge(salary: salary))
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
    respond_to do |format|
      if @proponent.update(proponent_params.merge(salary: salary))
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

  private

  def set_proponent
    @proponent = Proponent.find(params[:id])
  end

  def proponent_params
    params.require(:proponent).permit(
      :name,
      :cpf,
      :birth_date,
      :residential_phone,
      :mobile_phone,
      addresses_attributes: [:id, :street, :number, :neighborhood, :city, :state, :zip_code, :_destroy],
    )
  end
end
