module Jekyll

  class Page

    def write(dest)
      unless self.data['link']
        path = destination(dest)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w') do |f|
          f.write(self.output)
        end
      end
    end

  end

end
