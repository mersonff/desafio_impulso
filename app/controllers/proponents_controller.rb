# frozen_string_literal: true

# app/controllers/proponents_controller.rb

class ProponentsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_proponent, only: [:edit, :update, :destroy]

  def index
    query = current_user.proponents.order(name: :asc)
    @proponents = if params[:search].present?
      Kaminari.paginate_array(query.search(params[:search])).page(params[:page]).per(5)
    else
      query.page(params[:page]).per(5)
    end

    respond_to do |format|
      format.html
      format.turbo_stream
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

    if @proponent.save
      respond_to do |format|
        format.html do
          redirect_to(
            proponents_path,
            notice: t("flash.actions.update.notice", resource_name: Proponent.model_name.human),
          )
        end
        format.turbo_stream do
          flash.now[:notice] = t("flash.actions.create.notice", resource_name: Proponent.model_name.human)
          render turbo_stream: [
            turbo_stream.append("proponents", partial: "proponent", locals: { proponent: @proponent }),
            turbo_stream.update("flash", partial: "layouts/flash"),
            turbo_stream.update("new_proponent", "")
          ]
        end
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.update("new_proponent", partial: "form", locals: { proponent: @proponent }),
            turbo_stream.update("flash", partial: "layouts/flash", locals: { flash: { error: @proponent.errors.full_messages.join(", ") } })
          ]
        }
      end
    end
  end

  def edit
  end

  def update
    salary = params[:proponent][:salary].delete(".").tr(",", ".")
    discount = params[:proponent][:inss_discount]&.delete(".")&.tr(",", ".")
    
    if @proponent.update(proponent_params.merge(salary: salary, inss_discount: discount))
      respond_to do |format|
        format.html do
          redirect_to(
            proponents_path,
            notice: t("flash.actions.update.notice", resource_name: Proponent.model_name.human),
          )
        end
        format.turbo_stream do
          flash.now[:notice] = t("flash.actions.update.notice", resource_name: Proponent.model_name.human)
          render turbo_stream: [
            turbo_stream.replace(dom_id(@proponent), partial: "proponent", locals: { proponent: @proponent }),
            turbo_stream.update("flash", partial: "layouts/flash")
          ]
        end
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.replace(dom_id(@proponent), partial: "form", locals: { proponent: @proponent }),
            turbo_stream.update("flash", partial: "layouts/flash", locals: { flash: { error: @proponent.errors.full_messages.join(", ") } })
          ]
        }
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
        render turbo_stream: [
          turbo_stream.remove(dom_id(@proponent)),
          turbo_stream.update("flash", partial: "layouts/flash")
        ]
      end
    end
  end

  def report_data
    respond_to do |format|
      format.json { render("report_data", status: :ok) }
    end
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
    salary = params[:salary]
    discount = Proponent.calculate_inss_discount(salary)
    
    # Envia o cálculo para o job em segundo plano para atualização futura
    CalculateDiscountJob.perform_async(salary)

    respond_to do |format|
      format.json { 
        render json: {
          inss_discount: discount,
          message: "Desconto calculado com sucesso"
        }
      }
    end
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
