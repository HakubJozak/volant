module ButtonHelper
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
            class: 'btn kdm-btn-delete',
            title: title

  end

end
