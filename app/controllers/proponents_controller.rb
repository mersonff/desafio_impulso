# frozen_string_literal: true

# app/controllers/proponents_controller.rb

class ProponentsController < ApplicationController
  before_action :set_proponent, only: [:show, :edit, :update, :destroy]

  def index
    @proponents = Proponent.page(params[:page]).per(5)
  end

  def show
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
        format.html { redirect_to(proponents_path, notice: "Proponent was successfully created.") }
        format.turbo_stream { flash.now[:notice] = "Proponent was successfully created." }
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
        format.html { redirect_to(proponents_path, notice: "Proponent was successfully updated.") }
        format.turbo_stream { flash.now[:notice] = "Proponent was successfully updated." }
      else
        render(:edit, status: :unprocessable_entity)
      end
    end
  end

  def destroy
    @proponent.destroy

    respond_to do |format|
      format.html { redirect_to(proponents_path, notice: "Proponent was successfully destroyed.") }
      format.turbo_stream { flash.now[:notice] = "Proponent was successfully destroyed." }
    end
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
