/**
* facebookFriends
* Thiago Lagden @thiagolagden | lagden@gmail.com
* jQuery plugin
*/;
(function($, window, document, undefined) {
    var pluginName = "facebookFriends";
    var defaults = {
        friends: null,
        placeholder: 'Encontre um amigo',
        select: 'selecionar',
        selectLimit: 5,
        titleSearch: 'Procurar amigo',
        filterCharacters: 2,
        friendFilteredClass: 'filtrado',
        useMalihu: false,
        onReady: null,
        onUpdate: null,
        onSelected: null,
        onUnselected: null
    };

    function Plugin(element, options) {
        this.element = element;
        this.$element = $(element);
        this.$facebookFriends = null;
        this.$input = null;
        this.$list = null;
        this.$li = null;
        this.selectqty = 0;
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;

        this.init();
    }

    Plugin.prototype = {
        init: function() {
            if (this.options.friends != null) this.setFriends(this.options.friends);
            this.build();
        },
        build: function() {
            var overflowId = 'overflow' + Math.floor((Math.random() * 1000) + 1) + new Date()
                .getTime();
            var $inputHtml = $('<div class="searchField"><label for="searchName">' + this.options.titleSearch + '</label> <input type="text" name="searchName" placeholder="' + this.options.placeholder + '"></div>');
            this.$facebookFriends = $('<div id="' + overflowId + '" class="overflow"></div>');
            this.$list = $(this.buildMarkup());
            this.$li = this.$list.find('li');
            this.$facebookFriends.append(this.$list);
            this.$element.append($inputHtml)
                .append(this.$facebookFriends);

            this.$input = this.$element.find('.searchField input:eq(0)');

            this.$input.on('keyup', {
                "that": this
            }, function(ev) {
                ev.data.that.filterFriends(this.value);
            })
                .on('keydown', function(ev) {
                if (ev.which === 13) {
                    ev.preventDefault();
                    ev.stopPropagation();
                }
            });

            this.$li.find('a:eq(0)')
                .on('click.selecionado', {
                "that": this
            }, function(ev) {
                ev.preventDefault();

                var $this = $(this);
                var f = $this.data('name');

                if ($this.hasClass('selecionado')) {
                    $this.removeClass('selecionado');
                    ev.data.that.selectqty--;

                    if (typeof(ev.data.that.options.onUnselected) == "function") ev.data.that.options.onUnselected($this);
                } else {
                    if (ev.data.that.selectqty < ev.data.that.options.selectLimit) {
                        ev.data.that.selectqty++;
                        ev.data.that.$element.data('name', f);
                        ev.data.that.$element.data('id', $this.data('id'));
                        //ev.data.that.$input.val(f);
                        //ev.data.that.filterFriends(f);
                        
                        $this.addClass('selecionado');
                        if (typeof(ev.data.that.options.onSelected) == "function") ev.data.that.options.onSelected($this);
                    }
                }
            });

            if (typeof(this.options.onReady) == "function") this.options.onReady(this.$facebookFriends);

            if (typeof($.fn.mCustomScrollbar) == "function" && this.options.useMalihu) this.$facebookFriends.mCustomScrollbar({
                theme: 'dark',
                mouseWheel: false,
                scrollButtons: {
                    enable: false
                }
            });

        },
        buildMarkup: function() {
            var i = 0,
                len = this.options.friends.length,
                html = '<ul>';

            for (i < len; len--; ++i)
            html += this.buildFriendMarkup(this.options.friends[i]);

            html += '</ul>';
            return html;
        },
        buildFriendMarkup: function(friend) {
            var name = friend.name;
            name = (name.length > 10) ? name.substring(0, 10) + '...' : name;

            return '' + '<li>' + '<a href="#" data-name="' + friend.name + '" data-id="' + friend.id + '">' + '<img src="//graph.facebook.com/' + friend.id + '/picture?width=82&amp;height=82" width="82" height="82" alt="' + friend.name + '">' + '<b>' + name + '</b>' + '<span></span>' + '</a>' + '</li>';
        },
        filterFriends: function(filter) {
            var i = 0,
                len = this.options.friends.length;
            numFilteredFriends = 0;
            this.$li.removeClass(this.options.friendFilteredClass);
            if (filter.length >= this.options.filterCharacters) {
                filter = filter.toUpperCase();

                for (i < len; len--; ++i) {
                    if (this.options.friends[i].upperCaseName.indexOf(filter) === -1) {
                        $(this.$li.get(i))
                            .addClass(this.options.friendFilteredClass);
                        numFilteredFriends += 1;
                    }
                }
            }

            if (typeof($.fn.mCustomScrollbar) == "function" && this.options.useMalihu) this.$facebookFriends.mCustomScrollbar("update");

            if (typeof(this.options.onUpdate) == "function") this.options.onUpdate();
        },
        setFriends: function(input) {
            if (!input || input.length === 0) return;

            var i = 0,
                len = this.options.friends.length;

            input = Array.prototype.slice.call(input);
            for (i < len; len--; ++i)
            input[i].upperCaseName = input[i].name.toUpperCase();

            input = input.sort(this.sortFriends);
            this.options.friends = input;
        },
        sortFriends: function(friend1, friend2) {
            if (friend1.upperCaseName === friend2.upperCaseName) {
                return 0;
            }
            if (friend1.upperCaseName > friend2.upperCaseName) {
                return 1;
            }
            if (friend1.upperCaseName < friend2.upperCaseName) {
                return -1;
            }
        },
        destroy: function() {
            //...
        }
    };

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
})(jQuery, window, document);