(function ($){
    'use strict'

    var pluginName = 'customCarousel';
    var defaults = {
        cols: 5,
        rows: 2,
        textArrowPrev: 'anterior',
        textArrowNext: 'próximo',
        classArrowPrev: 'customCarousel-arrow-prev',
        classArrowNext: 'customCarousel-arrow-next',
        changeBy: 5,
    }

    function Plugin(element, options) {
        this.element = element;
        this.$element = $(element);
        this.$wrap = null;
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.page = 0;
        this.lastpage = 0;
        this.liW = 0;
        this.liH = 0;

        this.init();
    }

    Plugin.prototype = {
        init: function() {
            this.build();
        },
        build: function() {
            var $wrap, o = this.options;

            $wrap = this.$element.parent();
            $wrap.addClass('customCarousel');
          
            $wrap.after('<div class="customCarousel-arrows"><a href="#prev" class="' + o.classArrowPrev + '">' + o.textArrowPrev + '</a><a href="#next" class="' + o.classArrowNext + '">' + o.textArrowNext + '</a></div>')
            this.$wrap = $wrap;
            this.resize();

            $wrap.width(o.cols * this.liW);
            $wrap.height(o.rows * this.liH);
            $wrap.css({'overflow': 'hidden', 'position': 'relative'});


            $wrap.data('customCarousel', this);

            $wrap.next().on("click","a." + o.classArrowNext + ":eq(0)", function(ev) {
                ev.preventDefault();
                
                if (!$(this).hasClass('disable')) {
                    $(this).parents('.customCarousel-arrows').prev().data('customCarousel').moveNext();
                }

                return false;
            });

            $wrap.next().on("click","a." + o.classArrowPrev + ":eq(0)", function(ev) {
                ev.preventDefault();

                if (!$(this).hasClass('disable')) {
                    $(this).parents('.customCarousel-arrows').prev().data('customCarousel').movePrev();
                }

                return false;
            });
        },
        resize: function() {
            var o = this.options,
            $lis = this.$element.find('li'),
            $li_exclude = this.$element.find('li.filtrado'),
            len = $lis.length - $li_exclude.length;

            this.liW = $lis.width() + Number($lis.css('margin-left').replace('px', '')) + Number($lis.css('margin-right').replace('px', ''));
            this.liH = $lis.height() + Number($lis.css('margin-top').replace('px', '')) + Number($lis.css('margin-bottom').replace('px', '')),

            this.$element.width(Math.ceil(len / o.rows) * this.liW);
            this.$element.css('left', '0px');

            this.page = 0;
            this.lastpage = Math.ceil(len / (o.rows * o.cols) );
            this.lastpage = (len % (o.rows * o.cols) == 0) ? this.lastpage - 1 : this.lastpage;
            
            this.update();
        },
        moveNext: function() {
            var posL, o = this.options,
            $lis = this.$element.find('li'),
            $li_exclude = this.$element.find('li.filtrado'),
            len = $lis.length - $li_exclude.length;

            if (this.page < this.lastpage) {
                this.page++;
                posL = -this.page * (o.changeBy * this.liW);

                if (posL < (-this.$element.width() + (o.cols * this.liW))) {
                    posL = -this.$element.width() + (o.cols * this.liW);
                }

                this.$element.animate({
                    'left': posL
                });
            }

            this.update();
        },
        movePrev: function() {
            var posL, o = this.options;            

            if (this.page > 0) {
                this.page--;                  
                posL = -this.page * (o.changeBy * this.liW);

                if (posL > 0) {
                    posL = 0;
                } else {
                    if (posL < (-this.$element.width() + (o.cols * this.liW))) {
                        posL = -this.$element.width() + (o.cols * this.liW);
                    }
                }

                this.$element.animate({
                    'left': posL
                });
            }
            this.update();
        },
        update: function() {
            var posL, o = this.options,
            min = o.cols * o.rows,
            $lis = this.$element.find('li'),
            $li_exclude = this.$element.find('li.filtrado'),
            len = $lis.length - $li_exclude.length,
            $prev = this.$wrap.next().find('a.' + o.classArrowPrev),
            $next = this.$wrap.next().find('a.' + o.classArrowNext);
            console.log(this.$wrap.next().get(0));

            if (len > min) {
                console.log('mostra');

                $prev.show();
                $next.show();

                $prev.removeClass('disable');

                if (this.page == 0) {
                    console.log('desativa prev');  
                    $prev.addClass('disable');
                } 

                $next.removeClass('disable');

                if (this.page == this.lastpage) {
                    $next.addClass('disable');
                } else {
                    if ((this.page == this.lastpage - 1) && (len % (o.cols * o.rows) != 0))  {
                        $next.addClass('disable');
                    }                   
                }
            } else {
                $prev.hide();
                $next.hide();
            }
        }
    }

    $.fn[pluginName] = function(options) {
        var args = arguments;
        if (options === undefined || typeof options === 'object') {
            return this.each(function() {
                if (!$.data(this, "plugin_" + pluginName)) $.data(this, "plugin_" + pluginName, new Plugin(this, options));
            });
        } else if (typeof options === 'string' && options[0] !== '_' && options !== 'init') {
            var returns;

            this.each(function() {
                var instance = $.data(this, 'plugin_' + pluginName);
                if (instance instanceof Plugin && typeof instance[options] === 'function') returns = instance[options].apply(instance, Array.prototype.slice.call(args, 1));

                if (options === 'destroy') $.data(this, 'plugin_' + pluginName, null);
            });

            return returns !== undefined ? returns : this;
        }
    };    
})(jQuery);