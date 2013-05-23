var bindInviewEntries;
var bindSubscriptionNavigation;
var bindSubscriptionGroupList;
var showRead = false;
$(document).ready(function(){
   
   $('a.hook').bind('inview', function(e,visible) {
    if( visible ) {
      $.getScript($(this).attr("href"));
     }
   });


   bindSubscriptionGroupList = function() {
        $('.subscription-group').bind('click', function() {
        $("#selectionGroup").html($(this).text())
      });
   };

   bindSubscriptionGroupList();
  
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
   bindSubscriptionNavigation();

   // sidebar refresh
   setInterval(loadSidebar, 120 * 1000);

   // initial subscription reading
   $('.feed-link').first().click();
   // subscription creation
   $("#modal-err").hide();
   $("#body-err").hide();
   $(".new-group .btn").tooltip();
   $('#new-group-link').click(function(){
     $("div.group-list").hide();
     $("div.new-group").show();
     $("div.new-group").css('display', 'inline');
     toggleSaveBtn(false);
   });

   $('#cancel-group-btn').click(function(){
      toggleGroupSaveControls(false);
   });

   $('#save-group-btn').click(function(){
      createSubscriptionGroup($("#new-group-name").val()); 
   });

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
      .fail(function(data) {
        if (data.status == 200) return; // not json 
        $("#body-err .msg").text('We were unable to serve this subscription.');
        $("#body-err").show(); 
      })
      .always(function(data, textStatus) { }); 
   }


   function removeSubscription(subs_id) {
     $.ajax({url: "/subscriptions/" + subs_id + ".json", 
             type: 'DELETE'
     })
      .done(function(data) { 
        //eval(data);
      })
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

   function createSubscriptionGroup(group_name) {
     $.post("/subscription_groups.json", 
             {
              'subscription_group[name]' : group_name
             }
     )
      .done(function(data) {
        var last_el = $(".group-list ul li.last");
        last_el.after("<li class='last'><a class='subscription-group' href='#'>" + group_name + "</a></li>");
        last_el.removeClass('last');
        bindSubscriptionGroupList(); 
      })
      .always(function(data, textStatus) { toggleGroupSaveControls(false); }); 
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

   function toggleGroupSaveControls(enabled) {
     $("div.group-list").toggle(!enabled);
     $("div.new-group").toggle(enabled);
     toggleSaveBtn(!enabled);

     if (enabled) {
       $("div.new-group").css('display', 'inline');
     }
     else {
      $("#subs-url").keyup();
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

    function isSavingGroup(enabled) {
      $("#save-group-btn").toggle(enabled);
      $("#cancel-group-btn").toggle(enabled);
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

     $(".title-link").click(function() {
        var el = $(this).closest("section");
        if (el.hasClass("unread")) {
          entryWasRead(el);
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
        var subLbl = "Add subscription";
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

   // sidebar group change and subs remove 
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

   // navigation bar actions
   $(".btn-show-unread").click(function(){
      showRead = !$(this).hasClass("active");
      $.post("/subscriptions/set_show_read.json",
      {
         'state': showRead
      })
      .done(function(data) { 
        $(".btn-show-unread").text(showRead? "Show only unread" : "Show read");
        loadSubscription($(".feed-link.active").attr("id"));
      })
      .fail(function() {
        $("#body-err .msg").text('We can\'t show that right now.');
        $("#body-err").show(); 
      })
   });
});


