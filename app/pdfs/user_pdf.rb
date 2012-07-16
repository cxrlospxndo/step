class UserPdf < Prawn::Document
	def initialize(user, cursos)
		super(top_margin: 50)
		@user = user
		text "#{@user.codigo} #{@user.info.fullname}", size: 30, style: :bold
		move_down 20

		cursos.each do |c|
			text c[:curso]+c[:codigo]+c[:seccion], size: 15

			evaluaciones = []
			c[:notas][:practicas].each do |row|
				p = []
				row.each do |val|
					p << val
				end
				evaluaciones << p
			end	
			c[:notas][:examenes].each do |row|
				p = []
				row.each do |val|
					p << val
				end
				evaluaciones << p
			end	
		  table [["Tipo de Examen", "Nota", "Reclamo", "%Desaprobados"]] + evaluaciones do 
		  	row(0).font_style = :bold
		  	self.row_colors = ["F0F0F0", "FFFFCC"]
		  end

			move_down 20
		end
	end
	
end