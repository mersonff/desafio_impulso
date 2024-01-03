# frozen_string_literal: true

module ApplicationHelper
  def bootstrap_flash_class(flash_type)
    case flash_type.to_sym
    when :notice then "success"
    when :alert, :error then "danger"
    when :warning then "warning"
    else "info"
    end
  end

  def title_for(object)
    if object.new_record?
      content_tag(:h2, "Novo #{I18n.t("activerecord.models.#{object.class.name.underscore}.one")}")
    else
      content_tag(:h2, "Editar #{I18n.t("activerecord.models.#{object.class.name.underscore}.one")}")
    end
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend("flash", partial: "layouts/flash")
  end
end
