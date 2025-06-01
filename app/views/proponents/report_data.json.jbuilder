# frozen_string_literal: true

json.labels([
  "Até R$ 1.412,00",
  "De R$ 1.412,01 a R$ 2.666,68",
  "De R$ 2.666,69 a R$ 4.000,03",
  "De R$ 4.000,04 a R$ 7.786,02"
])

json.values(Proponent.data_for_chart)
