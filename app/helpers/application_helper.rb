module ApplicationHelper
	def show_me eva, value

		value[eva].delete_if { |v| v =~ /--/}
		html =""
	   	if value[eva].size == 0
	   		html << "No hay notas de #{eva}!"
	   	else
	   		html <<	"#{eva.titleize}: #{value[eva].join(",")}"
	   	end
	   	html
	end
end
