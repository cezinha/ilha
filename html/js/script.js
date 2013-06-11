function saved() {
    console.log('OK');
}

var App = {
    access_token: null,
    Util: {
        isEmail: function(email) {
          var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
          return regex.test(email);
        }
    },
    init: function(access_token) {
        this.access_token = access_token;

        $('#fb-button').hide();

        FB.api('/me', function(user) {
            if (user) {
                $('#Nome').val(user.name);
                $('#Email').val(user.email);
            }
        });

        FB.api('/me/friends', function(response) {
            $('#formfriends').data('friends', response);
            App.syncFriends();
        });
    },
    syncFriends: function() {
        var frmFriends = $('#formfriends');
        var friends = frmFriends.data('friends');
        var combos = $("#fbfriends").facebookFriends({
            "friends": friends.data
            , "useMalihu": false
            , onSelected: function(el) {
                console.log('onSelected')
                console.log(el.data('name'))
                App.control.addUser(el.data('name'), el.data('id'));
                
                /*var f = el.siblings('input:eq(0)');
                if(f.length > 0) {
                    console.log('selected:' + el.data('name') )
                    f.val('{"id": "' + el.data('id') + '", "name": "' + el.data('name') + '"}');

                }*/
            }
            , onUpdate: function(el) {
                $('#fbfriends .customCarousel').data('customCarousel').resize();
            }
            , onUnselected: function(el) {
                console.log('onUnselected')
                App.control.removeUser(el.data('id'));

                /*var f = el.siblings('input:eq(0)');
                if(f.length > 0) {
                    console.log('unselected:' + el.data('name') )
                }*/
            }

        });

        $('#fbfriends .overflow').show();
        $('#fbfriends ul').customCarousel();

        $('#bt-pronto').on('click', 'a', function(e) {
            e.preventDefault();

            var error = false; 

            if (App.control.findEmpty() != -1) {
               console.log('mensagem: não foram selecionados 5 amigos');
               error = true;
            } else {
                if ($('#Nome').val().length < 5) {
                    $('#Nome').parent().find('label:eq(0)').append('<span class="error">* Preencha o nome corretamente.</span>');
                    error = true;
                }
                if (!App.Util.isEmail($('#Email').val())) {
                    $('#Email').parent().find('label:eq(0)').append('<span class="error">* Preencha o e-mail corretamente.</span>');
                    error = true;
                }                
            }

            if (!error) {
                App.confirm();
            }

            return false;
        });

        $('ul.dados input').click(function() {
            $('span.error').remove();
        });
    },
    updateFriends: function() {
        console.log('updateFriends:');
        $('#flashIlha').get(0).updateFriends(App.control.users);
    },
    confirm: function() {
        $('#flashIlha').get(0).preview();

        /*var nomes, 
        users = [], 
        len = App.control.users.length;

        for (var i = 0 ; i < len ; i ++) {
            users.push('<strong>' + App.control.users[i].name + '</strong>');
        }
        nomes = users.join(', ');
        nomes = nomes.substring(0, nomes.lastIndexOf(',')) + " e" + nomes.substring(nomes.lastIndexOf(',')+1, nomes.length);

        $('#lightbox .popup p').html('Você escolheu ' + nomes + '.<br />São eles que você quer levar para a ilha?');
        */
       $('#lightbox').show();

        App.center();
        $(window).resize(function(e) {
            e.preventDefault();

            App.center();

            return false;
        });
    },
    saved: function() {
        console.log('publicado');
    },
    cancel: function() {
        console.log('cancelado');
    },
    publish: function(imgData) {
        console.log('publish');
        var form = $('<form enctype="multipart/form-data"></form>');
        var formdata = new FormData(form);
        formdata.append('access_token', this.access_token);
        formdata.append('message', "Teste");
        formdata.append('image', imgData);
        formdata.append('fileName', 'teste-app.png');

        /*var formdata = {
            access_token: this.access_token,
            message: "teste",
            image: imgData,
            fileName: 'teste-app.png'
        }*/
        
        FB.api('/me/photos', 'post', formdata, function(response) {
            if (!response || response.error) {
                alert('Error occured: ' + JSON.stringify(response.error));
            } else {
                alert('Post ID: ' + response);
            }
        });

        /*var formdata = {
            access_token: this.access_token,
            message: "teste",
            source: imgData
        };

        $.ajax({
            url: "https://graph.facebook.com/me/photos",
            data: formdata,
            contentType: 'multipart/form-data',
            cache: false,
            type: 'POST',
            success: function(data){
                alert("POST SUCCESSFUL");
            },
            error: function(data) {
                console.log('error');
                console.log(data);
            }
        });*/        
    },
    center: function() {
        var posL = Number(($(window).width() - $('#lightbox .popup').width()) / 2),
        posT = Math.round(($(window).height() - $('#lightbox .popup').height()) / 2); 

        $('#lightbox .popup').css({
            left: posL,
            top: posT
        });

        $('#flashIlha').css({
            left: posL,
            top: posT,
            position: 'fixed'
        });
    },
    control: {
        idx: 0,
        users: new Array( { id: '-1' }, { id: '-1' }, { id: '-1' }, { id: '-1' }, { id: '-1' }),
        addUser: function(name, id) {
            id = String(id);

            if (this.findUser(id) == -1) {
                if (this.idx > -1) {
                    var upIdx = this.idx;

                    this.users[this.idx] = { name: String(name), id: id};
                    App.updateFriends();

                    this.idx = this.findEmpty(upIdx);

                    return upIdx;
                }
            }
            return -1;
        },
        findEmpty : function(curr) {
            var len = this.users.length;

            for (var i = curr ; i < len; i++) {
                if (this.users[i].id == '-1') {
                    return i;
                }
            }
            for (var i = 0 ; i < len; i++) {
                if (this.users[i].id == '-1') {
                    return i;
                }
            }
            return -1;
        },
        findUser: function(id) {
            id = String(id);

            var found = -1;
            var len = this.users.length;

            if (len > 0) {
                for (var i = 0 ; i < len ; i++) {
                    if (this.users[i] && this.users[i].id == id) {
                        found = i; 
                        break;
                    }
                }
            }

            return found;
        },
        removeUser: function(id) {
            id = String(id);

            var findId = this.findUser(id),
            len = this.users.length;

            if (findId > -1) {
                this.users[findId] = { id: '-1' };
                this.idx = findId;


                var emptyCells = 0;
                for (var i = 0 ; i < len; i++) {
                    if (this.users[i].id == '-1') {
                        emptyCells ++;
                    }
                }
                if (emptyCells == len) {
                    this.idx = 0;
                }

                App.updateFriends();

                return true;
            }

            return false;
        }
    }
}