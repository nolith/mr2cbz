require 'mechanize'
require 'fileutils'

module Mr2cbz
  TITLE_MATCHER = /(.+)\s(\d+)\s-\sPage\s(\d+)/

  class Manga
    MANGA_LIST_URI = 'http://www.mangareader.net/alphabetical'.freeze
    def initialize(name)
      @browser = Manga.get_a_browser
      @name = name
    end

    def self.get_a_browser
      Mechanize.new do |agent|
        agent.user_agent_alias = 'Mac Safari'
      end
    end

    def self.list
      to_ret = {}
      get_a_browser.get(MANGA_LIST_URI) do |page|
        page.search('div.series_col li').each do |li|
          link = (li / 'a')[0]
          completed = !(li / 'span.mangacompleted').empty?
          yield [link.text, completed] if block_given?
          to_ret[link.text] = completed
        end
      end
      to_ret
    end

    def download(from, to, keep_temp=false)
      @browser.get(MANGA_LIST_URI) do |page|
        page = page.link_with(:text => @name).click
        title = page.at("h2.aname").text
        puts "Manga title: #{title}"
        chapter = from
        page.links_with(:text => %r{^#{title}\s+\d+$}i).each do |chapter_link|
          chapter_link.text =~ %r{^#{title}\s+(\d+)$}i
          chap_n = $1.to_i
          if (chap_n != chapter)
            puts "Skipping chapter #{chap_n}"
            next
          end

          #removes all the non word char from titile and
          # prepend '0's to chapter number up to 3 char
          sane_folder = chapter_link.text.gsub(/\W/, '_')
          sane_folder_match  = sane_folder.match /^(.+)_(\d+)$/
          sane_folder = "%s_%03d" % sane_folder_match.captures
          puts "Downloading #{chapter_link.text} in #{sane_folder}"

          img_page = @browser.click chapter_link
          this_chapter = chapter
          page = 1
          while chapter == this_chapter

            dest = File.join(sane_folder, ("%03d.jpg" % page))
            puts "Downloading #{img_page.image.alt}"
            img_page.image.fetch.save(dest)

            img_page = img_page.link_with(:text => 'Next').click
            mm = TITLE_MATCHER.match(img_page.image.text)
            break if mm.nil?
            this_chapter = mm.captures[1].to_i
            page = mm.captures[2]
          end

          # Give the path of the temp file to the zip outputstream,
          #   it won't try to open it as an archive.
          # Zip::ZipOutputStream.open("#{sane_folder}.cbz") do |zos|
          #   Dir.glob(File.join(sane_folder, '*.jpg')) do |file|
          #     # Create a new entry with some arbitrary name
          #     zos.put_next_entry(File.basename file)
          #     # Add the contents of the file, don't read the stuff linewise if its binary, instead use direct IO
          #     zos.print IO.read(file)
          #   end
          # end
          `zip -0 #{sane_folder}.cbz #{sane_folder}/*`
          puts "#{sane_folder}.cbz created!"
          FileUtils.rm_rf sane_folder unless keep_temp

          chapter+=1
          break if ( chapter > to)
        end
      end
    end

  end
end
