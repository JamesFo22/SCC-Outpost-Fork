class IndexedServicesSerializer < ActiveModel::Serializer
  def attributes(*args)
    object.attributes.symbolize_keys.except(
      :visible, 
      :notes_count, 
      :ofsted_reference_number,                              
      :old_ofsted_external_id, 
      :ofsted_item_id, 
      :organisation_id, 
      :approved,                              
      :label_list, 
      :discarded_at, 
      :marked_for_deletion
    )
  end

  has_many :locations do
    object.locations.where(visible: true)
  end

  has_many :contacts do
    object.contacts.where(visible: true)
  end

  belongs_to :organisation

  has_many :taxonomies
  has_many :regular_schedules
  has_many :cost_options

  has_one :local_offer

  def visible_from
    DateTime.strptime(object.visible_from, '%Y-%m-%d').to_time.utc if object.visible_from
  end

  def visible_to
    DateTime.strptime(object.visible_to, '%Y-%m-%d').to_time.utc if object.visible_to
  end
end