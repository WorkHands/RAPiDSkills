class API::V1::OccupationSerializer
  include FastJsonapi::ObjectSerializer

  link :self, :url

  attributes :title,
             :rapids_code,
             :onet_code,
             :onet_page_url,
             :term_length_min,
             :term_length_max

  attribute :kind do |object|
    object.class.name.underscore.gsub('_occupation','')
  end

  attribute :title_aliases do |object|
    object.title_aliases.join(", ")
  end
end
