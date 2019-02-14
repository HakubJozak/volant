module ButtonHelper

  def create_button(klass, params: {}, css: nil, &block)
    route = "new_internal_#{klass.name.underscore}_path"
    url   = public_send(route, params)
    css   = "btn btn-success #{css}"

    icon     = fa('plus')
    i18n_key = klass.model_name.i18n_key
    title    = [ t('common.new'), klass.model_name ]

    label = if block_given?
              capture(&block)
            else
              [ icon, title ].join(' ').html_safe
            end

    link_to label,
            url,
            class: css,
            title: I18n.t("activerecord.models.#{i18n_key}.new")
  end


  def delete_button(record,
                    url: nil,
                    remote: false,
                    confirm: nil,
                    label: nil,
                    params: {})

    type    = record.class.model_name.human
    name    = record.try(:name)
    confirm = I18n.t('dialog.delete', name: name, type: type) if confirm.nil?

    params.reverse_merge!(ru: url_for)

    title = [ I18n.t('common.delete'), name ].join(' ')
    url   = url   || polymorphic_path([:internal, record ], params)
    short = label || I18n.t('common.delete')
    icon  = fa('trash-o')


    link_to "#{icon} Delete".html_safe,
            url,
            'data-confirm': confirm,
            method: :delete,
            remote: remote,
            class: 'btn btn-danger',
            title: title

  end

end
