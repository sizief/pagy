# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/semantic
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for semantic-ui: it returns the html with the series of links to the pages
    def pagy_semantic_nav(pagy)
      html, link, p_prev, p_next = +'', pagy_link_proc(pagy, 'class="item"'), pagy.prev, pagy.next

      html << (p_prev ? %(#{link.call p_prev, '<i class="left small chevron icon"></i>', 'aria-label="previous"'})
                      : %(<div class="item disabled"><i class="left small chevron icon"></i></div>))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(#{link.call item})                      # page link
                elsif item.is_a?(String) ; %(<a class="item active">#{item}</a>)     # current page
                elsif item == :gap       ; %(<div class="disabled item">...</div>)   # page gap
                end
      end
      html << (p_next ? %(#{link.call p_next, '<i class="right small chevron icon"></i>', 'aria-label="next"'})
                      : %(<div class="item disabled"><i class="right small chevron icon"></i></div>))
      %(<div class="pagy-nav-semantic pagy-semantic-nav ui pagination menu" aria-label="pager">#{html}</div>)
    end
    Pagy.deprecate self, :pagy_nav_semantic, :pagy_semantic_nav

    # Compact pagination for semantic: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_semantic_compact_nav(pagy, id=caller(1,1)[0].hash)
      html, link, p_prev, p_next, p_page, p_pages = +'', pagy_link_proc(pagy, 'class="item"'), pagy.prev, pagy.next, pagy.page, pagy.pages

      html << %(<div id="pagy-nav-#{id}" class="pagy-nav-compact-semantic pagy-semantic-compact-nav ui compact menu" role="navigation" aria-label="pager">)
        html << link.call(MARKER, '', %(style="display: none;" ))
        (html << link.call(1, '', %(style="display: none;" ))) if defined?(TRIM)
        html << (p_prev ? %(#{link.call p_prev, '<i class="left small chevron icon"></i>', 'aria-label="previous"'})
                        : %(<div class="item disabled"><i class="left small chevron icon"></i></div>))
        input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem; margin: 0 0.3rem">)
        html << %(<div class="pagy-compact-input item">#{pagy_t('pagy.compact', page_input: input, count: p_page, pages: p_pages)}</div> )
        html << (p_next ? %(#{link.call p_next, '<i class="right small chevron icon"></i>', 'aria-label="next"'})
                        : %(<div class="item disabled"><i class="right small chevron icon"></i></div>))
      html << %(</div><script type="application/json" class="pagy-compact-json">["#{id}", "#{MARKER}", "#{p_page}", #{!!defined?(TRIM)}]</script>)
    end
    Pagy.deprecate self, :pagy_nav_compact_semantic, :pagy_semantic_compact_nav

    # Responsive pagination for semantic: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_semantic_responsive_nav(pagy, id=caller(1,1)[0].hash)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy, 'class="item"'), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = (p_prev ? %(#{link.call p_prev, '<i class="left small chevron icon"></i>', 'aria-label="previous"'})
                               : %(<div class="item disabled"><i class="left small chevron icon"></i></div>))
      responsive[:items].each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(#{link.call item})                      # page link
                          elsif item.is_a?(String) ; %(<a class="item active">#{item}</a>)     # current page
                          elsif item == :gap       ; %(<div class="disabled item">...</div>)   # page gap
                          end
      end
      tags['after'] = (p_next ? %(#{link.call p_next, '<i class="right small chevron icon"></i>', 'aria-label="next"'})
                              : %(<div class="item disabled"><i class="right small chevron icon"></i></div>))
      script = %(<script type="application/json" class="pagy-responsive-json">["#{id}", #{tags.to_json},  #{responsive[:widths].to_json}, #{responsive[:series].to_json}]</script>)
      %(<div id="pagy-nav-#{id}" class="pagy-nav-responsive-semantic pagy-semantic-responsive-nav ui pagination menu" role="navigation" aria-label="pager"></div>#{script})
    end
    Pagy.deprecate self, :pagy_nav_responsive_semantic, :pagy_semantic_responsive_nav

  end
end
