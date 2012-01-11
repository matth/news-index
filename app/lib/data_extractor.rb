module DataExtractor

  def self.extract(html)
    if !html.scan(/emp-decription/).empty?
      VideoDocument.new(html)
    elsif !html.scan(/id="pictureGallery"/).empty?
      PictureGalleryDocument.new(html)
    elsif !html.scan(/class="story-body"/).empty?
      ArticleDocument.new(html)
    else
      raise "Unknown type for #{url}"
    end
  end

  class Video
    attr_accessor :playlist, :width, :height, :holding_image, :external_id
    def initialize(playlist, width, height, holding_image, external_id)
      @playlist = playlist
      @width = width
      @height = height
      @holding_image = holding_image
      @external_id = external_id
    end
  end

  class Image
    attr_accessor :url, :width, :height, :description
    def initialize(url, width, height, description = '')
      @url = url
      @width = width
      @height = height
      @description = description
    end
    def area
      width * height
    end
    def ==(image)
      false if image.class != self.class
      url == image.url && width == image.width && height == image.height
    end
  end

  class Document

    attr_accessor :html, :type

    def initialize(html)
      @html = Nokogiri::HTML.parse(html)
    end

    def title
      @title ||= html.xpath('//meta[@property="og:title"]/@content').first.value
    end

    def description
      @description ||= html.xpath('//meta[@name="Description"]/@content').first.value
    end

    def publication_date
      @publication_date ||= Time.parse html.xpath('//meta[@name  ="OriginalPublicationDate"]/@content').first.value
    end

    def url
      @url ||= html.xpath('//meta[@property="og:url"]/@content').first.value
    end

    def site_name
      @site_name ||= html.xpath('//meta[@property="og:site_name"]/@content').first.value
    end

    def site_section
      @site_section ||= html.xpath('//meta[@name="Section"]/@content').first.value
    end

    def cps_id
      @cps_id ||= html.xpath('//meta[@name="CPS_ID"]/@content').first.value
    end

    def thumbnail
      @thumbnail ||= begin
        img = html.xpath('//meta[@property="og:image"]/@content')
        img.empty? ? nil : img.first.value
      end
    end

    def related_links
      @related_links ||= html.xpath('//ul[@class="related-links-list"]/li/a/@href').map do |href|
        href.value if href.value =~ /^http\:\/\//
        "http://www.bbc.co.uk" + href.value
      end.compact
    end

    def images
      @images ||= html.xpath('//img').reject do |img|
        img.xpath('@width').empty? || img.xpath('@height').empty?
      end.map do |img|
        url    = img.xpath('@src').first.value
        width  = img.xpath('@width').first.value.to_i
        height = img.xpath('@height').first.value.to_i
        description = img.xpath('@alt').empty? ? nil : img.xpath('@alt').first.value
        Image.new(url, width, height, description)
      end.reject do |img|
        img.area < 40_000
      end.uniq
    end

    def videos
      @videos ||= html.xpath('//object').reject do |obj|
        obj.xpath('param[@name="width"]').empty? ||
        obj.xpath('param[@name="height"]').empty? ||
        obj.xpath('param[@name="playlist"]').empty? ||
        obj.xpath('param[@name="externalIdentifier"]').empty?
      end.map do |obj|
        width  = obj.xpath('param[@name="width"]/@value').first.value.to_i
        height = obj.xpath('param[@name="height"]/@value').first.value.to_i
        playlist = obj.xpath('param[@name="playlist"]/@value').first.value
        external_id = obj.xpath('param[@name="externalIdentifier"]/@value').first.value
        holding_image = obj.xpath('param[@name="holdingImage"]/@value').empty? ? nil : obj.xpath('param[@name="holdingImage"]/@value').first.value
        Video.new(playlist, width, height, holding_image, external_id)
      end
    end

  end

  class ArticleDocument < Document
    def body
      @body ||= begin
        html.xpath('//*[@class="story-body"]/p').reject do |ptag|
          !ptag.xpath('a').empty? && ptag.xpath('a/@href').first.value =~ /\/modules\/sharetools\/share/
        end.map do |ptag|
          "<p>#{ptag.inner_html.strip}</p>"
        end.join("\n").strip
      end
    end
  end

  class VideoDocument < Document
    def body
      @body ||= begin
        html.xpath('//div[@class="emp-decription"]/p').map do |ptag|
          "<p>#{ptag.inner_html.strip}</p>"
        end.join("\n").strip
      end
    end
  end

  class PictureGalleryDocument < Document
    def body
      @body ||= begin
        html.xpath('//ul[@id="gallery"]/li/span[@class="picGalCaption"]').map do |ptag|
          "<p>#{ptag.inner_html.strip}</p>"
        end.join("\n").strip
      end
    end

    def images
      @images ||= begin
        html.xpath('//ul[@id="gallery"]/li/a').map do |atag|
          url = atag.xpath('@href').first.value
          description = atag.xpath('img/@alt').empty? ? nil : atag.xpath('img/@alt').first.value
          Image.new(url, 0, 0, description)
        end
      end
    end

  end

end