module DataExtractor

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

    attr_accessor :html

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
      @cps_d ||= html.xpath('//meta[@name="CPS_ID"]/@content').first.value
    end

    def thumbnail
      @thumbnail ||= html.xpath('//meta[@property="og:image"]/@content').first.value
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

end