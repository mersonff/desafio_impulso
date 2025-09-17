# frozen_string_literal: true

class InssCalculatorService
  # Faixas INSS 2023
  INSS_BRACKETS = [
    { min: 0.0, max: 1412.0, rate: 0.075 },
    { min: 1412.01, max: 2666.68, rate: 0.09 },
    { min: 2666.69, max: 4000.03, rate: 0.12 },
    { min: 4000.04, max: 7786.02, rate: 0.14 },
  ].freeze

  INSS_CEILING = 876.97 # Teto do INSS 2023

  def initialize(salary)
    @salary = parse_salary(salary)
  end

  def calculate
    return 0.0 if @salary.blank? || @salary <= 0

    # Se o salário for maior que o teto, retorna o valor máximo
    return INSS_CEILING if @salary > INSS_BRACKETS.last[:max]

    calculate_progressive_discount
  end

  private

  attr_reader :salary

  def parse_salary(salary_value)
    case salary_value
    when String
      # Remove pontos e substitui vírgula por ponto
      salary_value.delete(".").tr(",", ".").to_f
    when Numeric
      salary_value.to_f
    else
      0.0
    end
  end

  def calculate_progressive_discount
    total_discount = 0.0
    remaining_salary = @salary

    INSS_BRACKETS.each do |bracket|
      break if remaining_salary <= 0

      # Calcula a parcela do salário que se enquadra nesta faixa
      bracket_salary = calculate_bracket_salary(remaining_salary, bracket)

      # Aplica a alíquota da faixa
      total_discount += bracket_salary * bracket[:rate]

      # Remove a parcela já calculada
      remaining_salary -= bracket_salary
    end

    # Arredonda para 2 casas decimais
    (total_discount * 100).floor / 100.0
  end

  def calculate_bracket_salary(remaining_salary, bracket)
    # Determina quanto do salário restante se enquadra nesta faixa
    bracket_max = remaining_salary + (@salary - remaining_salary)

    if bracket_max <= bracket[:max]
      # Todo o salário restante se enquadra nesta faixa
      remaining_salary
    else
      # Apenas parte do salário se enquadra nesta faixa
      bracket[:max] - [@salary - remaining_salary, bracket[:min] - 0.01].max
    end
  end
end
