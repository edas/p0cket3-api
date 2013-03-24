require 'p0cket3/retrieve_request'

module P0cket3
  module Retrieve

    # forward some calls to a new RetrieveRequest object
    (
      (RetrieveRequest::VALUES.keys - [ :favorite ]) +
      (RetrieveRequest::VALUES[:detail] - [ true, false, nil ]) +
      (RetrieveRequest::VALUES[:state] - [ :all ]) +
      (RetrieveRequest::VALUES[:content] - [ nil ]).collect { |key| "#{key}s".to_sym } +
      (RetrieveRequest::VALUES[:sort] - [ nil ]).collect { |key| "by_#{key}".to_sym } +
      [ :where, :untagged, :all, :favorites, :limit ]
    ).each do |m|
      define_method m, ->(*args, &block) do
        r = options[:new_retrieve_request].call
        r.client = self
        r.send(m, *args, &block)
      end

    end

    def retrieve(where={}, options={})
      options = self.options.deep_merge(options)
      params = retrieve_params(where).deep_merge(
        consumer_key: options[:consumer_key],
        access_token: options[:access_token]
      )
      data = connection.post( options[:retrieve_path], params).body
      retrieve_result(data)
    end

  protected

    def retrieve_result(data)
      item_factory = options[:item_factory]
      data["list"].to_a.sort { |a,b|
        return -1 if a.nil?
        return 1 if b.nil?
        a[1]["sort_id"].to_i <=> b[1]["sort_id"].to_i
      }.collect { |a|
        item_factory.call(a[1])
      }
    end

    def retrieve_params(where)
      where = where.where if where.kind_of? RetrieveRequest
      where = where.clone
      over = { }
      case where[:favorite]
        when true then over[:favorite] = 1
        when false then over[:favorite] = 0
      end
      over[:tag] = "_untagged_" if where[:tag]==false
      where[:detailType] = where[:detail]
      where.delete(:detail)
      where[:contentType] = where[:content]
      where.delete(:content)
      case where[:detailType]
        when true then over[:detailType] = "complete"
        when false then over[:detailType] = "simple"
      end
      over[:offset] = nil if where[:count].nil?
      over[:since] = where[:since].to_i if where[:since].kind_of? DateTime
      where.deep_merge(over).delete_if {|key,value| value.nil? }
    end

  end
end
