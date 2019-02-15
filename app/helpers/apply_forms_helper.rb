module ApplyFormsHelper

  def apply_form_state_icon(state)
    return unless state.present?
    key = state.downcase

    icon = case key
             when "not_paid" then 'upload'
             when "paid" then 'money'
             when "accepted" then 'thumbs-up'
             when "rejected" then 'thumbs-down'
             when "asked" then 'envelope'
             when "infosheeted" then 'file'
             when "confirmed" then 'suitcase'
             when "cancelled" then 'times'
             else ''
           end

     content_tag :span, class: "fa-stack state-icon #{key}" do
       fa 'circle', css: "fa-stack-2x #{key}"
       fa key, css: "fa-stack-1x #{key}"
     end

#        <span class="fa-stack state-icon #{key}" title="#{info}">
#          <i class="fa fa-stack-2x fa-circle #{key}"></i>
#          <i class="fa fa-stack-1x fa-#{icon} fa-inverse #{key}"></i>
#        </span>

  end

# Ember.Handlebars.helper 'apply-form-state-icon', (state) ->
#   if state?
#     key = if typeof state isnt 'string'
#             info = state.get('info')
#             state.get('name').toLowerCase()
#           else
#             info = state
#             state

#     icon = switch key
#              when "not_paid" then 'upload'
#              when "paid" then 'money'
#              when "accepted" then 'thumbs-up'
#              when "rejected" then 'thumbs-down'
#              when "asked" then 'envelope'
#              when "infosheeted" then 'file'
#              when "confirmed" then 'suitcase'
#              when "cancelled" then 'times'
#              else ''

#      html = """
#        <span class="fa-stack state-icon #{key}" title="#{info}">
#          <i class="fa fa-stack-2x fa-circle #{key}"></i>
#          <i class="fa fa-stack-1x fa-#{icon} fa-inverse #{key}"></i>
#        </span>
#      """
#      new Handlebars.SafeString html




# Ember.Handlebars.helper 'apply-form-action-icon', (name) ->
#   icons = {
#     accept: 'thumbs-o-up'
#     reject: 'thumbs-o-down'
#     ask: 'envelope-o'
#     infosheet: 'file'
#     confirm: 'suitcase'
#     pay: 'money'
#     email: 'envelope-o'
#     cancel: 'times'
#   }
#   icon = "<i class='fa fa-#{icons[name]}'></i>"
#   new Handlebars.SafeString(icon)

end
