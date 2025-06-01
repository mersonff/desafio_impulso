# frozen_string_literal: true

module MonetaryParser
  extend ActiveSupport::Concern

  private

  def parse_monetary_value(value)
    return nil if value.blank?
    value.delete(".").tr(",", ".").to_f
  end

  def parse_monetary_params(params)
    return params if params.blank?

    # Cria uma cópia dos parâmetros para não modificar o original
    parsed_params = params.dup

    if parsed_params[:salary].present?
      parsed_params[:salary] = parse_monetary_value(parsed_params[:salary])
    end

    if parsed_params[:inss_discount].present?
      parsed_params[:inss_discount] = parse_monetary_value(parsed_params[:inss_discount])
    end

    parsed_params
  end

  def params_with_parsed_values(params_method = nil)
    # Se não for fornecido um método de parâmetros, usa o padrão do controller
    params_method ||= "#{controller_name.singularize}_params"
    
    # Obtém os parâmetros e faz o parsing
    params = send(params_method)
    parse_monetary_params(params)
  end
end 