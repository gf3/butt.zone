Many of you may have probably seen Paul Irish's clever 
[conditional &lt;html&gt; tag][conditional-html] solution which is now part of 
[HTML5 Boilerplate][html5-boilerplate]. Yet you may be left wondering how to 
do this in your HAML templates without making a big mess. Luckily, I've written
a simple Rails/Padrino helper for you!

### Helper

``` ruby
def conditional_html( lang = "en", &block )
  haml_concat Haml::Util::html_safe <<-"HTML".gsub( /^\s+/, '' )
    <!--[if lt IE 7 ]>              <html lang="#{lang}" class="no-js ie6"> <![endif]-->
    <!--[if IE 7 ]>                 <html lang="#{lang}" class="no-js ie7"> <![endif]-->
    <!--[if IE 8 ]>                 <html lang="#{lang}" class="no-js ie8"> <![endif]-->
    <!--[if IE 9 ]>                 <html lang="#{lang}" class="no-js ie9"> <![endif]-->
    <!--[if (gte IE 9)|!(IE)]><!--> <html lang="#{lang}" class="no-js"> <!--<![endif]-->      
  HTML
  haml_concat capture( &block ) << Haml::Util::html_safe( "\n</html>" ) if block_given?
end
```

**Note:** For Padrino you'll have to replace `haml_concat` with
`concat_content` and `capture` with `capture_html`.

### Usage

You can choose to pass it a block or not, personally, I prefer not to. Less 
indenting == more win, as well, the closing &lt;/html&gt; tag is optional.

``` haml
!!! 5

- conditional_html 'en-CA'

%head
  %title Website

%body
  = yield
```

[conditional-html]: http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/ "Paul Irish's Conditional <html> tag"
[html5-boilerplate]: http://html5boilerplate.com/ "Default markup and styles for HTML5 sites"

