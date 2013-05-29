var bindSubscriptionNavigation;
var bindSubscriptionGroupList;
var getSelectedSubscriptionId;
var setSelectedSubcription;
var loadSidebar;
var updateActiveReadCount;
var decrementActiveReadCount;
var expandGroup;
var collapseGroup;

$(document).ready(function(){
   'use strict';
  
   var refreshIntervalInMinutes = 10;

   setSelectedSubcription = function(subsId){
      $.cookie('selSubscriptionId', subsId);
   };

   getSelectedSubscriptionId = function(){
     return $.cookie('selSubscriptionId');
   };

   function setGroupCollapsed(groupId, status) {
     $.cookie('group-' + groupId, status);
   }

   function getGroupCollapsed(groupId) {
     return $.cookie('group-' + groupId);
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

   bindSubscriptionGroupList = function() {
        $('.subscription-group').bind('click', function() {
        $("#selectionGroup").html($(this).text())
      });
   };

   bindSubscriptionGroupList();

   expandGroup = function(groupEl){
      groupEl.nextUntil(".group").toggle(true);
      groupEl.find(".unreadcnt").remove();
      groupEl.html(groupEl.text());
      groupEl.removeClass("collapsed");
      setGroupCollapsed(groupEl.attr("id"), false);
   }
   
   collapseGroup = function(groupEl) {
      groupEl.nextUntil(".group").toggle(false);
      groupEl.html("<i class='icon-plus-sign'></i>" + groupEl.text());
      groupEl.addClass("collapsed");
            //<span class='unreadcnt'>25</span>
      var uCount = 0;
      groupEl.nextUntil(".group").each(function(){
          var itemUnreadCnt = $(this).find(".unreadcnt").text();
          if (itemUnreadCnt.length > 0)
            uCount += parseInt(itemUnreadCnt);
      });

      if (uCount > 0) {
        groupEl.append("<span class='unreadcnt'>" + uCount + "</span>");
      }

      setGroupCollapsed(groupEl.attr("id"), true);
   }

   // subscription onclick functionality
   bindSubscriptionNavigation = function() {
    $('.feed-link').bind('click', function(){
       $('.feed-link').removeClass('active');
       $(this).addClass('active');
       loadSubscription($(this).attr("id"));
       setSelectedSubcription($(this).attr("id"));
    });

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

    //sidebar-nav-fixed
    $(".sidebar-nav-fixed").hover(
    function () {
      $(this).css("overflow-y", "auto");
    },
    function () {
      $(this).css("overflow-y", "hidden");
    }
    );

    // after sidebar load set active again
    $(".feed-link#" + getSelectedSubscriptionId()).addClass('active');

    // group toggle
    $("li.group").bind('click', function(){
        var group = $(".group#" + $(this).attr('id'));
        if ($(this).hasClass('collapsed')) {
          // expand
          expandGroup(group);
        }
        else { //collapse
          collapseGroup(group);
        }
    });

    // set initial group status
    $("li.group").each(function(){
      var groupId = $(this).attr('id');
      if (getGroupCollapsed(groupId)) {
          collapseGroup($(this));
      }
    });
  }
  
  bindSubscriptionNavigation();
   
  decrementActiveReadCount = function(){
      var unread_cnt = parseInt($(".feed-link.active .unreadcnt").text());
      if (unread_cnt > 0)
        $(".feed-link.active .unreadcnt").html(unread_cnt - 1);
   }

   function loadSubscription(subs_id) {
      if (subs_id === undefined) return;

      $.ajax({
        url: "/subscriptions/" + subs_id + ".js",
        type: "GET"
        //dataType: "script"
      })
      .done(function(data) {
        //eval(data);
      })
      .fail(function(data) {
        if (data.status == 200) return; // not json 
        $("#body-err .msg").text('We were unable to serve this subscription.');
        $("#body-err").show(); 
      })
      .always(function(data, textStatus) {  }); 
   }

   loadSidebar = function() {
      $.ajax({ url: "/subscription_sidebar.js"
      , statusCode: {
              401: function() {
             }}})
      .done(function(data) { 
        eval(data);
      })
   };

   $("ul.nav-list").disableSelection();

    // sidebar refresh
    setInterval(loadSidebar, refreshIntervalInMinutes * 60 * 1000);

    // initial subscription reading
    if (null == getSelectedSubscriptionId()) {
      setSelectedSubcription($('.feed-link').first().attr("id"));
    }
    $(".feed-link#" + getSelectedSubscriptionId()).click();

});
