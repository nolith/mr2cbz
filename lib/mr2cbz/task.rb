require 'thor'
require 'mr2cbz'

module Mr2cbz
  class Task < Thor
    #desc "example FILE", "an example task"
    #method_option :delete, :aliases => "-d", :desc => "Delete the file after parsing it"
    #def example(file)
    #  puts "You supplied the file: #{file}"
    #  delete_file = options[:delete]
    #  if delete_file
    #    puts "You specified that you would like to delete #{file}"
    #  else
    #    puts "You do not want to delete #{file}"
    #  end
    #end

    desc "list","List all the available manga"
    def list
      Manga.list { |title, completed| puts "#{title} #{'[completed]' if completed}" }
    end

    desc "get MANGA FROM TO", "downloads the required MANGA from number FROM to number TO"
    def get(manga, from, to)
      m = Manga.new(manga)
      m.download(from.to_i, to.to_i)
    end
  end
end
