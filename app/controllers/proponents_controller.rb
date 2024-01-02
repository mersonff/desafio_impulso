# frozen_string_literal: true

# app/controllers/proponents_controller.rb

class ProponentsController < ApplicationController
  before_action :set_proponent, only: [:show, :edit, :update, :destroy]

  def index
    @proponents = Proponent.includes(:addresses).page(params[:page]).per(5)
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

    respond_to do |_format|
      if @proponent.save
        # message = I18n.t("activerecord.messages.proponent.create.success")
        #
        # format.html { redirect_to(proponents_path) }
        # format.turbo_stream do
        #   flash.now[:notice] = message
        #   render(turbo_stream:
        #            turbo_stream.append(
        #              "proponents",
        #              partial: "proponents/proponent",
        #              locals: { proponent: @proponent },
        #            ))
        # end
        respond_to do |format|
          format.html { redirect_to(proponents_path, notice: "Proponent was successfully created.") }
          format.turbo_stream { flash.now[:notice] = "Proponent was successfully created." }
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
        format.html { redirect_to(proponents_path) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            @proponent,
            partial: "proponents/show",
            locals: { proponent: @proponent },
          ))
        end
      else
        format.html { render(:edit) }
        format.turbo_stream do
          render(
            turbo_stream: turbo_stream.replace(
              @proponent,
              partial: "form",
              locals: { proponent: @proponent },
            ),
            status: :unprocessable_entity,
          )
        end
      end
    end
  end

  def destroy
    @proponent.destroy

    respond_to do |format|
      format.html { redirect_to(proponents_path, notice: "Proponent was successfully destroyed.") }
      format.turbo_stream
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
