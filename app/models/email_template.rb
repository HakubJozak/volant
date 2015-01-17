require 'ostruct'

class EmailTemplate < ActiveRecord::Base
  self.table_name = 'new_email_templates'

  # used only for apply form submission
  def call(apply_form)
    @apply_form = apply_form
    MessageData.new(to: eval_field(to),
                    cc: eval_field(cc),
                    bcc: eval_field(bcc),
                    from: eval_field(from),
                    subject: eval_field(subject),
                    body: eval_field(body))
  end

  def eval_field(field_template)
    @handlebars ||= Handlebars::Context.new
    template = @handlebars.compile(field_template || '')
    template.call(data)
  end

  private
  
  def data
    raise 'Missing apply_form' unless @apply_form 
    @data ||= {
      volunteer: @apply_form.volunteer.attributes,
      workcamps_list: workcamps_list
    }
  end

  def workcamps_list
    items = @apply_form.workcamps.reload.map do |wc|
      "<li>#{wc.code} - #{wc.name}, #{wc.begin} - #{wc.end}</li>"
    end.join("\n")

    "<ol>#{items}</ol>"
  end
  
  class MessageData
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :to,:from,:cc,:bcc,:subject,:body

    def attributes
      { to: nil,from: nil,cc: nil,bcc: nil,subject: nil,body: nil}
    end
  end
  
end
