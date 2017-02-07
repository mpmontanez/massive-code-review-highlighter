class ComparisonHtmlWriter

  def self.write_html_header(html_file)
    # Begin the HTML document.
    html_file.write("<html>\n")
    html_file.write("<head>\n")
    html_file.write("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\" integrity=\"sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u\" crossorigin=\"anonymous\">")
    html_file.write("<link rel=\"stylesheet\" type=\"text/css\" href='../css/comparison.css' />\n")
    html_file.write("</head>\n")
    html_file.write("<body>\n")
    html_file.write("<div class=\"container\">\n")
  end

  def self.write_html_to_open_panel(html_file, line, anchor)
    html_file.write("<div class=\"panel panel-default\">")
    html_file.write("<div class=\"panel-heading\">#{line} <a name=\"#{anchor}\"></a></div>")
    html_file.write("<table class=\"table\">\n")
  end

  def self.determine_line_style(line)
    line_style = ''

    if line.start_with? '+++'
      line_style = 'warning'
    elsif line.start_with? '+'
      line_style = 'success'
    elsif line.start_with? '---'
      line_style = 'warning'
    elsif line.start_with? '-'
      line_style = 'danger'
    elsif line.start_with? '@@'
      line_style = 'warning'
    end

    line_style
  end

  def self.write_html_for_comparison_line(html_file, line)
    line_style = self.determine_line_style(line)
    html_file.write("<tr class=\"#{line_style}\"><td><pre>#{line}</pre></td></tr>\n")
  end

  def self.write_html_to_close_panel(html_file)
    html_file.write("</table>\n")
    html_file.write("<div class=\"panel-footer info\"></div>")
    html_file.write("</div>\n")
  end

  def self.write_html_footer(html_file, anchors)
    # Close the HTML file.
    html_file.write("</div>\n")

    # File navigator.
    html_file.write("<nav class=\"navbar navbar-default navbar-fixed-top\">")
    html_file.write("<div class=\"container\">")
    html_file.write("<b>Modified Files: </b>")
    html_file.write("<select id=\"file-selector\"\">")
    anchors.each do |anchor|
      html_file.write("<option>#{anchor}</option>")
    end
    html_file.write("</select>")
    html_file.write("</div>")
    html_file.write("</nav>")

    html_file.write("</body>\n")
    html_file.write("</html>\n")
  end

end