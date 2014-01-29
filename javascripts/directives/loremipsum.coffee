"use strict"

angular
    .module('boilerplate.directives.loremipsum', [])

    .directive('loremipsum', [->
        link: (scope, element, attrs, controller) ->
            element.text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullum inveniri verbum potest quod magis idem declaret Latine, quod Graece, quam declarat voluptas. Nam quid possumus facere melius? Sic enim censent, oportunitatis esse beate vivere. Hanc ergo intuens debet institutum illud quasi signum absolvere. An potest, inquit ille, quicquam esse suavius quam nihil dolere? Sed in rebus apertissimis nimium longi sumus. Si stante, hoc natura videlicet vult, salvam esse se, quod concedimus; Duo Reges: constructio interrete. Idem fecisset Epicurus, si sententiam hanc, quae nunc Hieronymi est, coniunxisset cum Aristippi vetere sententia. Quo modo autem philosophus loquitur?')
    ])

