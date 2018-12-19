# frozen_string_literal: true

module MinimalResponders
  extend ActiveSupport::Concern

  included do
    helper_method :return_url_param
  end

  protected

    def respond_with(record, *args)
      case action_name.to_sym
      when :create
        respond_to_create(record, *args)
      when :update
        respond_to_update(record, *args)
      when :destroy
        respond_to_destroy(record, *args)
      else
        fail "Unknown action #{action_name}"
      end
    end

    def respond_to_create(record, location: nil)
      if record.save
        name = record.try(:to_label) || record.name
        msg = I18n.t('flash.actions.create.notice', resource_name: name)
        location ||= polymorphic_path(record)
        redirect_to return_url(record, location), notice: msg
      else
        render :new
      end
    end

    def respond_to_update(record, location: nil, fail_view: :edit)
      name = record.try(:to_label) || record.name

      if record.valid?
        msg = I18n.t('flash.actions.update.notice', resource_name: name)
        redirect_to return_url(record, location), notice: msg
      else
        msg = I18n.t('flash.actions.update.error', resource_name: name)
        flash.alert = msg
        render fail_view, status: 422
      end
    end

    def respond_to_destroy(record, location: nil)
      name = record.try(:to_label) || record.name
      msg = I18n.t('flash.actions.destroy.notice', resource_name: name)
      redirect_to return_url(record, location), notice: msg
    end

    private
      def return_url_param
        params.dig(:ru)
      end

      def return_url(record, location)
        return_url_param.presence ||
          location ||
          polymorphic_path(:internal, record.class)
      end

end
