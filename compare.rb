require_relative 'comparison_generator'

puts 'Generating an HTML file to compare massive pull request changes.'
ComparisonGenerator.generate_from_diff_file('../example-diff-2.txt')
puts 'Done.'
