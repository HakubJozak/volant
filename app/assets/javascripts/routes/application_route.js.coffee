Volant.ApplicationRoute = Ember.Route.extend({
  beforeModel: ->
#    @transitionTo('workcamps')

  model: ->
   Ember.RSVP.hash({
       current_user:
         name: 'Jakub Hozak'

      years: [ 'All years',2015,2014,2013,2012,2011,2010]

      intentions: ["AGRI", "ANIMAL", "ARCH", "CONS", "CULT", "ECO", "EDU", "ELDE", "ETHNO", "FEST", "HERI", "HIST", "KIDS", "LANG", "LEAD", "MANU", "PLAY", "REFUGEE", "RENO", "SOCI", "TEACH", "TEEN", "ENVI", "FRENCH", "GERMAN", "RUSSIAN", "ZOO", "DISA", "SERBIAN", "ITALIAN", "SPANISH", "PŘÍPRAVNÉ ŠKOLENÍ", "YOGA", "PEACE", "ART", "SPOR", "STUD", "SENIOR", "FAMILY", "WHV"]

      tags: ["senior", "family", "teenage", "spanish", "german", "italian", "married", "possible_duplicate", "special form", "extra fee", "french", "motiv.letter"]
#      intentions: @store.find('organizations')
    });

})
