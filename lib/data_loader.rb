# -*- coding: utf-8 -*-
module DataLoader

  def self.load_emails
    subjects = {}
    subjects["accept"] = "Prihlaska na projekt '{{wc.name}}' byla uspesna!"
    subjects["infosheet"] = "Posilame Ti infosheet na workcamp '{{wc.name}}'"
    subjects["ask"] = "VEF: {{volunteer.name}} for {{wc.name}}({{wc.code}})"
    subjects["reject"] = "Nepodarilo se Te prihlasit na zadny projekt"
    subjects["submitted"] = "Prihlaska byla prijata do systemu INEX-SDA"
    subjects["mail"] = ""

    descs = {}
    descs["accept"] = "Posílá se po přijetí na projekt"
    descs["infosheet"] = "Posílá se spolu s infosheetem"
    descs["ask"] = "Posílá se jako doprovodný text s VEF"
    descs["reject"] = "Posílá se, pokud byly všechny možnosti pro přijetí vyčerpány"
    descs["submitted"] = "Posílá se automaticky po přijetí přihlášky"
    descs["mail"] = "Hlavní šablona, která obaluje většinu emailů"

    [ 'accept', 'ask', 'infosheet', 'reject', 'submitted', 'mail' ].each do |action|
      f = File.new("#{Rails.root}/db/default_email_templates/#{action}.html.erb")

      body = ''
      f.each_line { |line| body += line}


      t = EmailTemplate.new(subject: subjects[action],
                            to: 'fake@there.net',
                            from: 'fake@here.net',                            
                            body: body,
                            title: descs[action],
                            action: action)
      t.save!
    end
  end

end
