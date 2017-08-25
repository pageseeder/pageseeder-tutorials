/**
 * Behaviour defined for the system globally
 */
jQuery(function( $ ) {
  "use strict";

  // expandable
  $(document).on('click', '[data-expand]', function(e) {
    $('#'+$(this).attr('data-expand')+'[data-expandable]').toggleClass('expanded');
    return false;
  });

  // autosuggest look
  $.widget("ui.autocomplete", $.ui.autocomplete, {
    _renderItem: function(ul, item) {
      if (item.image) {
        var $div = $('<div>').append($('<label>').html(item.highlight ? item.highlight : item.value));
        if (item.title) { $div.append($('<label>').text(item.title)); }
        if (item.year)  { $div.append($('<label>').text(item.year+', '+item.country)); }
        return $( "<li class='suggestion' />" )
          .append($("<img>").attr('src', item.image))
          .append($div)
          .appendTo(ul);
      } else {
        return $( "<li>" )
          .append($("<a>").append(item.label))
          .appendTo(ul);
      }
    }
  });
  // autosuggest
  $('input.autosuggest').each(function() {
    var $input = $(this);
    var autosuggestSource = function(req, res) {
      var href = $input.attr('data-href');
      var term = $input.val();
      $.get(href, {'term' : term}, function(data) {
        var suggestions = $('suggestions suggestion', data).map(function() {
          var $suggestion = $(this);
          if ($input.hasClass('movies')) {
            return {
              'image'    : $suggestion.find('field[name=image]').text() || $suggestion.attr('payload'),
              'title'    : $suggestion.find('field[name=title]').text(),
              'year'     : $suggestion.find('field[name=year],field[name=prop_year]').text(),
              'country'  : $suggestion.find('field[name=country],field[name=prop_country]').text(),
              'highlight': $suggestion.attr('highlight'),
              'value'    : $suggestion.attr('text')
            };
          } else {
            return {
              'label' : $suggestion.attr('highlight'),
              'value' : $suggestion.attr('text')
            };
          }
        }).get();
        res(suggestions);
      }).error(function(xhr) {
        res(["Failed to load values: "+$('error', xhr.responseXML).attr('message')]);
      });
    };

    $input.autocomplete({
      source: autosuggestSource,
      minLength: 2
    });
  });

  // toggle search forms (films/bios)
  $('.search a.toggle-search').click(function() {
    var $a = $(this);
    $a.parent().find('.selected').removeClass('selected');
    $a.addClass('selected');
    $('.search-form, .results').hide();
    $($a.attr('href')).show();
    return false;
  });

  // search form
  $('.search-form, #search-form').each(function() {
    var $form = $(this);

    // facets
    $('.facets .facet-values li[data-field][data-value] a').click(function() {
      $(this).parent().toggleClass('selected');
      $form.submit();
    });

    // facet selection
    $('#go-facets').click(function() {$form.submit();});

    // pagination
    $('.pagination .page a').click(function() {
      $form.append($('<input name="page" type="hidden" />').val($(this).attr('data-page'))).submit();
      return false;
    });

    // submit form
    $form.submit(function() {
      // compute facets
      var facets = $('#choice li input:checked').map(function() {return $(this).val();}).get().join(',');
      if (!$form.find('input[name=term]').val()) {
        window.location = $form.attr('action').replace('/advanced', '')+(facets ? '?facets='+encodeURI(facets) : '');
        return false;
      }
      // avoid double click
      var $submit = $form.find('button');
      if ($submit.hasClass('disabled')) { return false; }
      $submit.addClass('disabled');
      // show spinner in results panel
      $('.results').html('<p><i class="fa fa-spin fa-spinner"></i> Loading...</p>');
      // add facets input
      if (!!facets) {
        $form.append($('<input name="facets" type="hidden" />').val(facets));
      }
      // add with input
      var criteria = $('.facets .facet-values .selected').map(function() {
        return $(this).attr('data-field')+':'+$(this).attr('data-value');
      }).get().join(',').trim();
      if (!!criteria) {
        $form.append($('<input name="with" type="hidden" />').val(criteria));
      }
    });
  });

  // bio links
  $(document).on('click', 'a.bio', function() {
    // run query
    $.get($(this).attr('href'), function(data) {
      // find results
      var $results = $('documents document', data);
      // if none, error
      if (!$results.length) {
        alert('Invalid person!');
        return;
      }
      // if only one, go there
      if ($results.length == 1) {
        window.location = '/bio/' + $results.find('field[name=index]').text() + '.html';
      } else {
        // remove previous one
        $('div.bios.reveal').remove();
        // show results and ask user to pick one
        var $choice = $('<div class="bios reveal reveal-modal" data-reveal="" aria-hidden="true" role="dialog">'+
                          '<h4>Load biography</h4>'+
                          '<div class="reveal-content"><ul class="choice"></ul></div>'+
                          '<a class="close-reveal" data-close="" aria-label="Close" href="#">&#215;</a>'+
                        '</div>').hide().appendTo('body');
//        $choice.on('click', '.close-reveal-modal', )
        $results.each(function() {
          var $li = $('<li><a href="/bio/'+$(this).find('field[name=index]').text()+'.html"></a></li>');
          $li.find('a').text($(this).find('field[name=prop_common-name]').text());
          $li.appendTo($choice.find('ul'));
        })
        var popup = new Foundation.Reveal($choice);
        popup.open();
      }
    });
    return false;
  });
});
