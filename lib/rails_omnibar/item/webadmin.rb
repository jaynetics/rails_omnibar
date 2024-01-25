class RailsOmnibar
  # adds fuzzy-searchable links to each defined resource index of ActiveAdmin etc.
  def add_webadmin_items(icon: default_admin_item_icon, prefix: nil, suffix: nil, suggested: false)
    if defined?(ActiveAdmin)
      add_active_admin_items(icon: icon, prefix: prefix, suffix: suffix, suggested: suggested)
    elsif defined?(RailsAdmin)
      add_rails_admin_items(icon: icon, prefix: prefix, suffix: suffix, suggested: suggested)
    else
      raise "#{__method__} currently only works with ActiveAdmin or RailsAdmin"
    end
  end

  def add_active_admin_items(icon: default_admin_item_icon, prefix: nil, suffix: nil, suggested: false)
    ActiveAdmin.load!

    ActiveAdmin.application.namespaces.each do |namespace|
      namespace.fetch_menu(ActiveAdmin::DEFAULT_MENU) # ensure menu is loaded

      namespace.resources.each do |res|
        next unless (res.controller.action_methods & ['index', :index]).any?
        next unless index = res.route_collection_path rescue next
        next unless label = res.menu_item&.label.presence

        title = [prefix, label, suffix].compact.join(' ')
        add_item(title: title, url: index, icon: icon, suggested: suggested)
      end
    end
  end

  def add_rails_admin_items(icon: default_admin_item_icon, prefix: nil, suffix: nil, suggested: false)
    admin_urls = RailsAdmin::Engine.routes.url_helpers

    RailsAdmin::Config.models.select(&:visible?).each do |model|
      next unless index = admin_urls.index_path(model.abstract_model.to_param)
      next unless label = model.label_plural # as used by rails_admin in sidebar

      title = [prefix, label, suffix].compact.join(' ')
      add_item(title: title, url: index, icon: icon, suggested: suggested)
    end
  end

  def default_admin_item_icon
    :document
  end
end
