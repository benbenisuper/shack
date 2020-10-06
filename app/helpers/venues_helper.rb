# frozen_string_literal: true

module VenuesHelper
  def translated_category(enum_key)
    I18n.t("activerecord.attributes.venue.categories.#{enum_key}")
  end

  def translated_activity(enum_key)
    I18n.t("activerecord.attributes.venue.activities.#{enum_key}")
  end

  def venue_category_for_select
    Venue::CATEGORIES.map { |category| [translated_category(category), category] }
  end

  def venue_activity_for_select
    Venue::ACTIVITIES.map { |activity| [translated_activity(activity), activity] }
  end
end