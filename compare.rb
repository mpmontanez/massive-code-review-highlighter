
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

class ComparisonGenerator

  def self.generate_from_diff_file(diff_file_path)
    # Open the diff file and read each line.
    diff_file_contents = File.open(diff_file_path).read
    diff_file_contents.gsub!(/\r\n?/, "\n")

    diff_files_per_document = 30
    html_document_count = 0
    file_number = 0
    files_in_html = []

    # Open the first HTML document.
    current_html_document = ComparisonGenerator.generate_new_html_file(html_document_count)

    diff_file_contents.each_line do |line|

      if line.start_with? 'diff'
        # Close the previous panel.
        unless file_number == 0
          ComparisonHtmlWriter.write_html_to_close_panel(current_html_document)
        end

        # Close and open a new HTML file if we've reached the max files per document.
        if file_number == diff_files_per_document
          # DEBUG For now, break at 100 files.
          if html_document_count > 10
            break
          end

          # Close the previous HTML document.
          ComparisonGenerator.complete_html_file(current_html_document, files_in_html)

          # Open a new HTML document.
          html_document_count += 1
          current_html_document = ComparisonGenerator.generate_new_html_file(html_document_count)

          # Reset variables.
          file_number = 0
          files_in_html = []
        end

        file_number += 1

        # Parse and collect the file name.
        file_name = line.split('b/')[-1].strip
        files_in_html << file_name

        # Open the panel to display the changes within the file.
        ComparisonHtmlWriter.write_html_to_open_panel(current_html_document, line, file_name)
        next
      end

      # Write line HTML.
      ComparisonHtmlWriter.write_html_for_comparison_line(current_html_document, line)

    end

    # Close the last file.
    ComparisonHtmlWriter.write_html_footer(current_html_document, files_in_html)
    current_html_document.close unless current_html_document.nil?
  end

  def self.generate_new_html_file(file_number)
    current_html_document = File.open("generated-html/comparison-#{file_number}.html", "w")
    ComparisonHtmlWriter.write_html_header(current_html_document)
    current_html_document
  end

  def self.complete_html_file(file, diff_files)
    # Close the previous HTML file.
    ComparisonHtmlWriter.write_html_footer(file, diff_files)
    file.close unless file.nil?
  end

end

puts 'Generating an HTML file to compare massive pull request changes.'
ComparisonGenerator.generate_from_diff_file('../example-diff-2.txt')
puts 'Done.'
