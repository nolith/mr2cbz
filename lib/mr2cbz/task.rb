require 'thor'
require 'mr2cbz'

module Mr2cbz
  class Task < Thor
    desc "list","List all the available manga"
    def list
      Manga.list { |title, completed| puts "#{title} #{'[completed]' if completed}" }
    end

    desc "get MANGA FROM [TO]",
         "downloads the required MANGA from number FROM to number TO. If TO is missing only one manga will be downloaded"
    method_option :keep_temp, :aliases => "--no-delete",
                  :type => :boolean, :default => false,
                  :desc => "Keep the jpeg folder after creating the CBZ"
    def get(manga, from, to=from)
      m = Manga.new(manga)
      m.download(from.to_i, to.to_i, options[:keep_temp])
    end
  end
end
