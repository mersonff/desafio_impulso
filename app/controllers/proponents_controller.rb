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
    @proponent = Proponent.new
    @proponent.user = current_user
    assign_resource(@proponent, proponent_params)

    respond_to do |format|
      if @proponent.save
        format.html do
          redirect_to(
            proponents_path,
            notice: t("flash.actions.create.notice", resource_name: Proponent.model_name.human),
          )
        end
        format.turbo_stream do
          message = t("flash.actions.create.notice", resource_name: Proponent.model_name.human)
          @proponents = current_user.proponents.page(params[:page]).per(5)

          streams = []
          streams << turbo_stream.update("proponents", partial: "proponents_list", locals: { proponents: @proponents })
          streams << turbo_stream.update("modal", "")
          add_flash_stream(streams, message)

          render(turbo_stream: streams)
        end
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.update(
            "modal",
            template: "proponents/new",
            locals: { proponent: @proponent },
          ))
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if update_resource(@proponent, proponent_params)
        format.html do
          redirect_to(
            proponents_path,
            notice: t("flash.actions.update.notice", resource_name: Proponent.model_name.human),
          )
        end
        format.turbo_stream do
          message = t("flash.actions.update.notice", resource_name: Proponent.model_name.human)

          streams = []
          streams << turbo_stream.replace(
            "proponent_#{@proponent.id}",
            partial: "proponent_card",
            locals: { proponent: @proponent },
          )
          streams << turbo_stream.update("modal", "")
          add_flash_stream(streams, message)

          render(turbo_stream: streams)
        end
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.update(
            "modal",
            template: "proponents/edit",
            locals: { proponent: @proponent },
          ))
        end
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
        message = t("flash.actions.destroy.notice", resource_name: Proponent.model_name.human)
        @proponents = current_user.proponents.page(params[:page]).per(5)

        streams = []
        streams << turbo_stream.update("proponents", partial: "proponents_list", locals: { proponents: @proponents })
        add_flash_stream(streams, message)

        render(turbo_stream: streams)
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
      "Até R$ 1.412,00",
      "De R$ 1.412,01 a R$ 2.666,68",
      "De R$ 2.666,69 a R$ 4.000,03",
      "De R$ 4.000,04 a R$ 7.786,02",
    ]
    @values = Proponent.data_for_chart
  end

  def calculate_inss_discount
    salary = params[:salary]
    discount = Proponent.calculate_inss_discount(salary)

    # Envia o cálculo para o job em segundo plano para atualização futura
    CalculateDiscountJob.perform_async(salary)

    respond_to do |format|
      format.json do
        render(json: {
          inss_discount: discount,
          message: "Desconto calculado com sucesso",
        })
      end
    end
  end

  private

  def set_proponent
    @proponent = Proponent.find(params[:id]).decorate
  end

  def flash_toast(message, type = "success")
    icon = type == "success" ? "check-circle-fill" : "exclamation-triangle-fill"
    %{
      <div class="toast align-items-center border-0 text-bg-#{type}" data-bs-delay="5000" data-controller="toast" data-action="hidden.bs.toast->toast#remove">
        <div class="d-flex">
          <div class="toast-body d-flex align-items-center">
            <i class="bi bi-#{icon} me-2"></i>
            #{message}
          </div>
          <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
      </div>
    }
  end

  def add_flash_stream(streams, message, type = "success")
    streams << turbo_stream.update("flash", "")
    streams << turbo_stream.append("flash", flash_toast(message, type))
  end

  def proponent_params
    params.require(:proponent).permit(
      :name,
      :cpf,
      :birth_date,
      :residential_phone,
      :mobile_phone,
      :salary,
      :inss_discount,
      addresses_attributes: [:id, :street, :number, :neighborhood, :city, :state, :zip_code, :_destroy],
    )
  end

  def update_resource(object, attributes)
    object.localized.update(attributes.to_h)
  end

  def assign_resource(object, attributes)
    object.localized.assign_attributes(attributes.to_h)
  end
end
