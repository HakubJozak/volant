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
            { code: 'infosheeted', label: 'Infosheet sent'},
            { code: 'asked', label: 'Asked'},
          ]
