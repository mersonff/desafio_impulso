# frozen_string_literal: true

json.labels([
  "Até R$ 1.045,00",
  "De R$ 1.045,01 a R$ 2.089,60",
  "De R$ 2.089,61 até R$ 3.134,40",
  "De R$ 3.134,41 até R$ 6.101,06",
])

json.values(Proponent.data_for_chart)
