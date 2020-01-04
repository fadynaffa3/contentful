class Space
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  def as_json(options={})
    attrs = super(options)
    attrs.delete("_id")
    attrs
  end
end
