puts 'Generating an HTML file to compare massive pull request changes.'

# Destination HTML file.
html_file = File.open("comparison.html", "w")

# Begin the HTML document.
html_file.write("<html>\n")
html_file.write("<head>\n")
html_file.write("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\" integrity=\"sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u\" crossorigin=\"anonymous\">")
html_file.write("<link rel=\"stylesheet\" type=\"text/css\" href='css/comparison.css' />\n")
html_file.write("</head>\n")
html_file.write("<body>\n")

# Open the diff file and read each line.
diff_file_contents = File.open('sample-diffs/diff.txt').read
diff_file_contents.gsub!(/\r\n?/, "\n")

html_file.write("<div class=\"container\">\n")

first_panel = true
line_number = 0
DIFF_FILES_PER_HTML = 30
file_number = 0
files_in_html = []

diff_file_contents.each_line do |line|

  if line.start_with? 'diff'
    unless first_panel
      html_file.write("</table>\n")
      html_file.write("<div class=\"panel-footer info\"></div>")
      html_file.write("</div>\n")

      if file_number >= DIFF_FILES_PER_HTML
        break
      end
    end

    file_number += 1

    # Parse and collect the file name.
    file_name = line.split('b/')[-1].strip
    files_in_html << file_name

    # Open the panel to display the changes within the file.
    html_file.write("<div class=\"panel panel-default\">")
    html_file.write("<div class=\"panel-heading\">#{line} <a name=\"#{file_name}\"></a></div>")
    html_file.write("<table class=\"table\">\n")
    first_panel = false
    next
  end

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

  html_file.write("<tr class=\"#{line_style}\"><td><pre>#{line}</pre></td></tr>\n")

  line_number += 1
end

# Close the HTML file.
html_file.write("</div>\n")

# File navigator.
html_file.write("<nav class=\"navbar navbar-default navbar-fixed-top\">")
html_file.write("<div class=\"container\">")
html_file.write("<b>Modified Files: </b>")
html_file.write("<select id=\"file-selector\"\">")
files_in_html.each do |file_name|
  html_file.write("<option>#{file_name}</option>")
end
html_file.write("</select>")
html_file.write("</div>")
html_file.write("</nav>")

html_file.write("</body>\n")
html_file.write("</html>\n")
html_file.close unless html_file.nil?

puts 'Done.'
