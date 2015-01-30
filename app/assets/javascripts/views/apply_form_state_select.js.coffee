Volant.ApplyFormStateSelect = Ember.Select.extend
  classNames: ["form-control"]
  optionValuePath: "content.code"
  optionLabelPath: "content.label"
  prompt: 'Any'

  content: [
            { code: 'without_payment', label: 'Not paid'},
            { code: 'accepted', label: 'Accepted'},
            { code: 'rejected', label: 'Rejected'},
            { code: 'cancelled', label: 'Cancelled'},
            { code: 'infosheeted', label: 'Infosheet Sent'},
            { code: 'on_project', label: 'On Project' },
            { code: 'alerts', label: 'Has Alert'},            
            { code: 'asked', label: 'Asked'},
          ]
