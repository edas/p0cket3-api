module P0cket3
  class RetrieveRequest

    VALUES = {
      state: [:unread, :archive, :all],
      favorite: [true, false, nil],
      tag: [String, false, nil],
      content: [:article, :video, :image, nil],
      sort: [:newest, :oldest, :title, :site, nil],
      detail: [:simple, :complete, true, false, nil],
      search: [String, nil],
      domain: [String, nil],
      since: [DateTime, nil],
      count: [Integer, nil],
      offset: [Integer]

    }
    DEFAULTS = {
      state: :unread,
      favorite: nil,
      tag: nil,
      content: nil,
      sort: nil,
      search: nil,
      domain: nil,
      since: nil,
      count: nil,
      offset: 0
    }
    attr_accessor :client
    attr_writer :where

    def initialize(client=nil, where=nil)
      where = DEFAULTS if where.nil?
      @client = client if client
      @where = where
    end

    def where(params=nil)
      return @where if params.nil?
      self.class.new(client, @where.merge(params))
    end

    def where=(params)
      @where = params
    end

    VALUES.each_key do |m|
      define_method m do |val|
        check(m, val)
        self.where(m => val)
      end unless m == :favorites
      define_method "#{m}=" do |val|
        check(m, val)
        @where[m] = val
      end
    end

    def favorites(val=true)
      check(:favorite, val)
      self.where(favorite: val)
    end

    def untagged
      self.where(tag: false)
    end

    def limit(val)
      count(val)
    end

    def archived
      self.where(state: :archive)
    end

    (VALUES[:detail] - [ true, false, nil ]).each do |m|
      define_method(m) { where(detail: m) }
    end

    (VALUES[:state] - [ :all ]).each do |m|
      define_method(m) { where(state: m) }
    end

    (VALUES[:content] - [ nil ]).each do |m|
      define_method((m.to_s + "s").to_sym) { where(content: m) }
    end

    (VALUES[:sort] - [ nil ]).each do |m|
      define_method(("by_" + m.to_s).to_sym) { where(sort: m) }
    end

    def retrieve(where={}, options={})
      where = @where.merge(where)
      client.retrieve(where, options)
    end

  protected

    def method_missing(method, *args, &block)
      if [ ].respond_to?(method)
        all.send(method, *args, &block)
      else
        raise NoMethodError, "undefined method `#{method}' for \"#{self}\":#{self.class.name}"
      end
    end

    def check(method, value, list=nil)
      list = VALUES[method] if list.nil?
      VALUES[method].each do |val|
        if val.kind_of? Class
          return if value.kind_of? val
        else
          return if val == value
        end
      end
      raise ArgumentError, "unexpected value '#{value.to_s}' for #{self.class.name}##{method}"
    end

  end

end
