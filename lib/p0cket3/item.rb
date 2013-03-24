require 'time'

module P0cket3
  class Item

    STATUSES = [
      :unread,
      :archived,
      :deleted
    ]
    TYPES = [
      :article,
      :image,
      :video,
      :index
    ]
    attr_reader :given
    attr_reader :resolved
    attr_writer :favorite
    attr_accessor :status
    attr_accessor :excerpt
    attr_accessor :type
    attr_writer :has_image
    attr_writer :has_video
    attr_accessor :word_count
    attr_accessor :tags
    attr_accessor :authors
    attr_accessor :images
    attr_accessor :videos
    attr_accessor :added_at
    attr_accessor :read_at
    attr_accessor :favorited_at
    attr_accessor :updated_at

    [:id, :url, :title].each do |m|
      define_method m do
        resolved.send(m) || given.send(m)
      end
    end

    def initialize
      @given = ItemIdentity.new
      @resolved = ItemIdentity.new
      @tags = [ ]
      @authors = [ ]
      @images = [ ]
      @videos = [ ]
    end

    def complete?
      @complete
    end

    def resolved?
      resolved.id
    end

    def favorite?
      @favorite
    end

    def favorite!
      @favorite = true
    end

    def unfavorite!
      @favorite = false
    end

    def unread!
      @status = :unread
    end

    def unread?
      @status == :unread
    end

    def archive!
      @status = :archived
    end

    def archived?
      @status == :archived
    end

    def delete!
      @status = :deleted
    end

    def deleted?
      @status == :deleted
    end

    def is_article?
      @type == :article
    end

    def is_image?
      @type == :image
    end

    def is_video?
      @type == :video
    end

    def is_index?
      @type == :index
    end

    def has_image?
      @has_image
    end

    def has_video?
      @has_video
    end

    def self.import(data)
      i = self.new
      i.given.id = data["item_id"]
      i.given.url = data["given_url"] if data["given_url"]
      i.given.title = data["given_title"] if data["given_title"]
      i.resolved.id = data["resolved_id"] if data["resolved_id"] and data["resolved_id"]!="0"
      i.resolved.url = data["resolved_url"] if data["resolved_url"]
      i.resolved.title = data["resolved_title"] if data["resolved_title"]
      i.favorite = ( (data["favorite"]=="1") ? true : false ) if data["favorite"]
      i.status = STATUSES[ data["status"].to_i ]
      i.type = :index if data["is_index"]=="1"
      i.type = :article if data["is_article"]=="1"
      # i.complete = ( (data["complete"] == 1) ? true : false) if data["complete"]
      case data["has_image"]
        when "2" then i.type = :image
        when "1" then i.has_image = true
        when "0" then i.has_image = false
      end
      case data["has_video"]
        when "2" then i.type = :video
        when "1" then i.has_video = true
        when "0" then i.has_video = false
      end
      i.word_count = data["word_count"].to_i if data["word_count"] and data["word_count"]!="0" and data["word_count"]!=""
      i.excerpt = data["excerpt"] if data["excerpt"] and data["excerpt"] != ""
      i.tags = data["tags"].values.collect { |t|
        ItemTag.new(t["tag"])
      } if data["tags"]
      i.authors = data["authors"].values.collect { |a|
        author = ItemAuthor.new
        author.id = a["author_id"] if a["author_id"]
        author.name = a["name"] if a["name"] and a["name"]!=""
        author.url = a["url"] if a["url"] and a["url"]!=""
        author
      } if data["authors"]
      i.images = data["images"].values.collect { |img|
        image = ItemImage.new
        image.item_id = img["item_id"] if img["item_id"]
        image.src = img["src"] if img["src"] and img["src"]!=""
        image.width = img["width"].to_i if img["width"] and img["width"]!="0" and img["width"]!=""
        image.height = img["height"].to_i if img["height"] and img["height"]!="0" and img["height"]!=""
        image.credit = img["credit"] if img["credit"] and img["credit"]!=""
        image.caption = img["caption"] if img["caption"] and img["caption"]!=""
        image
      } if data["images"]
      i.videos = data["videos"].values.collect { |v|
        video = ItemVideo.new
        video.id = v["vid"] if v["vid"] and v["vid"]!=""
        video.item_id = v["item_id"] if v["item_id"]
        video.src = v["src"] if v["src"] and v["src"]!=""
        video.width = v["width"].to_i if v["width"] and v["width"]!="0" and v["width"]!=""
        video.height = v["height"].to_i if v["height"] and v["height"]!="0" and v["height"]!=""
        video.type = v["type"] if v["type"] and v["type"]!="" and v["type"]!="0"
        video
      } if data["videos"]
      i.added_at = DateTime.strptime(data["time_added"], "%s") if data["time_added"] and data["time_added_"] != "0"
      i.updated_at = DateTime.strptime(data["time_updated"], "%s") if data["time_updated"] and data["time_updated"] != "0"
      i.read_at = DateTime.strptime(data["time_read"], "%s") if data["time_read"] and data["time_read"] != "0"
      i.favorited_at = DateTime.strptime(data["time_favorited"], "%s") if data["time_favorited"] and data["time_favorited"] != "0"
      return i
    end

  end

  class ItemIdentity
    attr_accessor :id
    attr_accessor :url
    attr_accessor :title
  end

  class ItemVideo
    attr_accessor :id
    attr_accessor :item_id
    attr_accessor :src
    attr_accessor :width
    attr_accessor :height
    attr_accessor :type
  end

  class ItemImage
    attr_accessor :item_id
    attr_accessor :src
    attr_accessor :width
    attr_accessor :height
    attr_accessor :credit
    attr_accessor :caption
  end

  class ItemAuthor
    attr_accessor :id
    attr_accessor :name
    attr_accessor :url
  end

  class ItemTag < String
  end

end
