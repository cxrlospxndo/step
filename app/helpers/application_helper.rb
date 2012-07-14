#encoding: utf-8
module ApplicationHelper
	# def show_me eva, value

	# 	value[eva].delete_if { |v| v =~ /--/}
	# 	html =""
	#    	if value[eva].size == 0
	#    		html << "No hay notas de #{eva}!"
	#    	else
	#    		html <<	"#{eva.titleize}: #{value[eva].join(",")}"
	#    	end
	#    	html
	# end
	def dar_formato number
			index = number.to_i - 1 
			orden = %w[1ero 2do 3ro 4to 5to 6to 7mo 8vo 9no 10mo]
			orden[index] 
			# require 'active_support/core_ext/integer/inflections'
			# number.to_i.ordinalize
	end
	def pretty curso
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
		ans.join(" ")
	end
end
