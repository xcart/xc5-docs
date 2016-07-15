require 'pathname'
require 'xmlsimple'

module Jekyll
  module ReferencePlugin

    class LinkTag < Liquid::Tag
      def initialize(tag_name, args, tokens)
        super
        title_match = /^["']([\s\S]*)['"]/.match(args)
        id_match = /(\S+?)(#[\S]*)?\s*$/.match(args)
        @title = title_match ? title_match.captures.first : ''
        @id = id_match ? id_match.captures.first : ''
        @hash = (id_match ? id_match.captures[1] : '') || ''
      end

      def render(context)
        @site = context.registers[:site]
        @config = context.registers[:site].config
        @page = context.environments.first["page"]
        baseurl = context['baseurl_lang']

        url = @site.data['links'][@id] ? @site.data['links'][@id][:link] + @hash : '404.html'

        markup = "[#{@title}](#{baseurl}/#{url})"

        return markup
      end
    end

    class ReferenceIndex < Jekyll::StaticFile
      def write(dest)
        true
      end
    end

    class IndexGenerator < Jekyll::Generator
      def generate(site)
        path = Pathname.new(site.dest) + site.config['index_path']

        index = site.pages.inject(Hash.new) do |memo, page|
          if page['title'] && page['identifier'] && page['path']
            link_parts = page['path'].split('/').slice(1..-1)
            link_parts.last.gsub!('md', 'html')
            link = link_parts.join('/')
            memo.store(page['identifier'], { "title": page['title'], "link": link })
          end
          memo
        end

        site.data['links'] = index

        File.open(path, 'w+') do |h|
          h.write XmlSimple.xml_out(index, {'NoAttr' => true, "RootName" => "refs", "XmlDeclaration" => true})
        end

        # Keep the sitemap.xml file from being cleaned by Jekyll
        site.static_files << Jekyll::ReferencePlugin::ReferenceIndex.new(site, site.dest, "/", site.config['index_path'])
      end
    end

  end
end

Liquid::Template.register_tag('link', Jekyll::ReferencePlugin::LinkTag)