var bindInviewEntries;
var bindSubscriptionNavigation;

$(document).ready(function(){
   
   $('a.hook').bind('inview', function(e,visible) {
    if( visible ) {
      $.getScript($(this).attr("href"));
     }
   });

   $("#modal-err").hide();

   $('.subscription-group').bind('click', function() {
      $("#selectionGroup").html($(this).text())
   });
  
   $("#subs-url").bind('keyup', function() {
    if (validateUrl($(this).val())) {
      toggleSaveBtn(true);
    }
    else {
      toggleSaveBtn(false);
    }
   }).keyup();

   $(".btn-save").bind('click', function() {
      createSubscription($("#subs-url").val(), 
                        $("#selectionGroup").html()); 
   });

   // subscription onclick functionality
   bindSubscriptionNavigation = function() {
    $('.feed-link').bind('click', function(){
       $('.feed-link').removeClass('active');
       $(this).addClass('active');
       loadSubscription($(this).attr("id"));
    });   
   }

   // initial subscription reading
   bindSubscriptionNavigation();
   $('.feed-link').first().click();

   function createSubscription(url, group) {
      isSaving(true);
      $.post("/subscriptions.json",
              initSubscription(url, group) 
      )
      .done(function(data) { 
        $('#subscriptionModal').modal('hide'); 
        addNewSubscription(data); 
      })
      .fail(function() {
        $("#modal-err .msg").text('We were unable to create this subscription.');
        $("#modal-err").show(); 
      })
      .always(function(data, textStatus) { isSaving(false); }); 
   }

   function initSubscription(url, group) {
      if (group != 'Group...')
        return {url: url, group: group};
      return {url: url};
   }

   function loadSubscription(subs_id) {
      $.get("/subscriptions/" + subs_id + ".js"
      )
      .done(function(data) { 
        eval(data);
      })
      .fail(function() {
        $("#modal-err .msg").text('We were unable to serve this subscription.');
        $("#modal-err").show(); 
      })
      .always(function(data, textStatus) { }); 
   }

   function updateSubscriptionGroup(subs_id, group_id) {
     $.ajax({url: "/subscriptions/" + subs_id + ".json", 
             type: 'PUT',
             data: {
                    'subscription[id]' : subs_id,
                    'subscription[group_id]' : group_id
                   }
     })
      .done(function(data) { 
        //eval(data);
        loadSidebar();
      })
   }

   function removeSubscription(subs_id) {
     $.ajax({url: "/subscriptions/" + subs_id + ".json", 
             type: 'DELETE'
     })
      .done(function(data) { 
        //eval(data);
      })
   }

   function loadSidebar() {
      $.get("/subscription_sidebar.js"
      )
      .done(function(data) { 
        eval(data);
      })
   }

   function toggleSaveBtn(enabled) {
      if (enabled) {
        $(".btn-save").fadeTo(0, 1);
        $(".btn-save").removeAttr('disabled');
      }
      else {
        $(".btn-save").fadeTo(0, 0.5);
        $(".btn-save").attr('disabled','disabled');
      } 
   }

   function isSaving(enabled) {
     if (enabled) {
       $(".btn-save").html("Saving...");
     }
     else {
       $(".btn-save").html("Save Changes");
     }
     toggleSaveBtn(!enabled);
   }

   function addNewSubscription(data) {
        toggleSaveBtn(true);
        isSaving(false); 
        $("#subs-url").val('');
        $("#selectionGroup").html("Group...");
        loadSidebar();
   }

    // scroll logic
    'use strict';

    var lastScrollTop = 0,
        st,
        direction;

    function detectDirection() {

        st = window.pageYOffset;

        if (st > lastScrollTop) {
            direction = "down";
        } else {
            direction = "up";
        }

        lastScrollTop = st;

        return  direction;

    }

    $(window).bind('scroll', function() {
        detectDirection();
    });

    // entry inview binding
    bindInviewEntries = function() {
     $('.entry').bind('inview', function(e,visible) {
      if( !visible && direction == 'down' && $(this).hasClass("unread")) {
       entryWasRead($(this));
      }
     });
    };

    function entryWasRead(entryEl) {

      $.post("/readentries.json",
      {
         'readentry[entry_id]': entryEl.attr("id"),
         'readentry[subscription_id]': $(".feed-link.active").attr("id")
      })
      .done(function(data) { 
        entryEl.fadeTo(0, 0.5);
        entryEl.removeClass("unread");
        entryEl.addClass("read");
        var unread_cnt = parseInt($(".feed-link.active .unreadcnt").text());
        if (unread_cnt > 0)
          $(".feed-link.active .unreadcnt").html(unread_cnt - 1);
      })
    }

    function toggleSubscriptionButton(active) {
        var el = $("a#trigger");
        var subLbl = "Add subscription...";
        var remLbl = "Drop here to remove";
        if (!active) {
          el.addClass("btn-danger");
          el.find("i").removeClass("icon-rss");
          el.find("i").addClass("icon-trash");
          el.html(el.html().replace(subLbl, remLbl));
        }
        else {
          el.removeClass("btn-danger");
          el.find("i").addClass("icon-rss");
          el.find("i").removeClass("icon-trash");
          el.html(el.html().replace(remLbl, subLbl));
        }
    }

   // sidebar drag
   var is_el_out = false;
   $("ul.nav-list").sortable({ 
     cancel: ".group", 
     beforeStop: function( event, ui ) {
        var subs_id = ui.item.attr("id");
        if (!is_el_out) {
          var new_group_id =  ui.item.prevAll(".group").attr("id");
          if (new_group_id == "0")
            new_group_id = "";
          updateSubscriptionGroup(subs_id, new_group_id);
        }
        else {
          // remove subscription
          ui.item.remove();
          removeSubscription(subs_id);
        }
        toggleSubscriptionButton(true);
     },
     activate: function(event, ui) {
        //console.log(ui);
        toggleSubscriptionButton(false);
     },
     out: function(event, ui) {
      is_el_out = true; 
     },
     over: function(event, ui) {
       is_el_out = false;
     }
   });

   $("ul.nav-list").disableSelection(); 
});


