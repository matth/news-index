class StoryBodyCounter
  def self.map
    <<-JS
    function() {
      if (this.html.match(/class="emp-decription"/gi)) {
        emit("emp-desc", {count : 1})
      } else if (this.html.match(/class="story-body"/gi)) {
        emit("story-body", {count : 1})
      } else if (this.html.match(/id="pictureGallery"/gi)) {
        emit("picture-gallery", {count : 1})
      }

      if (this.html.match(/og:title/gi)) {
        emit("og:title", {count : 1})
      }
      if (this.html.match(/og:url/gi)) {
        emit("og:url", {count : 1})
      }
      if (this.html.match(/og:image/gi)) {
        emit("og:image", {count : 1})
      }

      if (this.html.match(/OriginalPublicationDate/gi)) {
        emit("OriginalPublicationDate", {count : 1})
      }
    }
    JS
  end

  def self.reduce
    <<-JS
    function(key, values) {
      var count = 0;
      values.forEach(function(value) {
        count += value.count;
      });
      return {count: count};
    }
    JS
  end

  def self.build(opts = {})
    hash = opts.merge({
      :out    => {:inline => true},
      :raw    => true
    })
    ArticleHtml.collection.map_reduce(map, reduce, hash)
  end

end

