module Jekyll
  class NavTreeTag < Liquid::Tag

    def render(context)
      @target = context['page']['permalink']
      build_site_map context.registers[:site].pages
      render_level('ROOT')
    end

    def render_level(level)
      nav = ''
      @children[level].each do | page |
        if page == @target
          nav += '<li class="current"><a href="' + page + '">' + @names[page].to_s + '</a><ul>'
          @children[page].each do | child |
            nav += '<li><a href="' + child + '">' + @names[child].to_s + '</a></li>'
          end
          nav += '</ul></li>'
        elsif @all_parents[@target].include? page
          nav += '<li><a href="' + page + '">' + @names[page].to_s + '</a><ul>'
          nav += render_level page
          nav += '</ul></li>'
        else
          nav += '<li><a href="' + page + '">' + @names[page].to_s + '</a></li>'
        end
      end
      nav
    end

    def build_site_map(pages)
      parents = {}
      @all_parents = {}
      @children = {'ROOT' => []}
      @names = {}
      pages.each do | page |
        page.dir = ''
        parents[page.url] = page.data['parent']
        @names[page.url] = page.data['title']
        @children[page.url] = []
      end
      pages.each do | page |
        @all_parents[page.url] = find_parents(page.url, parents)
      end

      pages.each do | page |
        @children[parents[page.url]] << page.url
      end
    end

    def find_parents(target, parents)
      if target == 'ROOT'
        []
      else
        [parents[target]] + find_parents(parents[target], parents)
      end
    end

  end

end

Liquid::Template.register_tag('nav_tree', Jekyll::NavTreeTag)