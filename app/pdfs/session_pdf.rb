class SessionPdf < Prawn::Document
  def initialize(data, notas)
    super(top_margin: 50)
    text "#{data[:codigo]} #{data[:nombre]}", size: 20, style: :bold
    move_down 20

    notas.each do |c|
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
      table [['Tipo de Examen', 'Nota', 'Reclamo', '%Desaprobados']] + evaluaciones do
        row(0).font_style = :bold
        self.row_colors = %w(F0F0F0 FFFFCC)
      end

      move_down 20
    end
  end

end