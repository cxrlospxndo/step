#encoding: utf-8
module ApplicationHelper
	def dar_formato number
    @orden = %w[1ero 2do 3ro 4to 5to 6to 7mo 8vo 9no 10mo]
    @orden[number.to_i - 1]
		# require 'active_support/core_ext/integer/inflections'
		# number.to_i.ordinalize
	end
	def pretty_name curso
		curso[-1]=""
		articulos=%w[de la con y ii i iii a un del]
		ans = []
		curso.downcase.split.each do |c|
			if articulos.include? c
				ans << c.gsub(/i/,'I').gsub(/ii/,'II').gsub(/iii/,'III')
			else
				ans << c.titleize.gsub(/Ñ/, 'ñ')
			end
		end
		ans.join(' ')
	end
  def self.to_csv data, notas, f
    CSV.generate(f) do |csv|
      csv << [data[:codigo], data[:nombre]]
      csv << []
      notas.each do |c|
        csv << [c[:curso]+c[:codigo]+c[:seccion]]
        csv << ["Tipo de Examen", "Nota", "Reclamo", "%Desaprobados"]
        c[:notas][:practicas].each do |row|
          csv << row
        end
        c[:notas][:examenes].each do |row|
          csv << row
        end
        csv << []
      end
    end
  end

end
