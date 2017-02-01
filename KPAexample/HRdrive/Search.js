      (function() {
          var $list,
              lastFilterId,
              lastFilterCallback,
              lastHideId,
              focused,
              inBounds,
              hideCallback = function () {
                  if (!focused && !inBounds) {
                      $(".hrm-breadcrumb-search .list-group").addClass("hide");
                      lastHideId = null;
                  }
              };

          $(document)
              .on("input", "#breadcrumb-search-box", function() {
                  if (lastFilterId) {
                      clearTimeout(lastFilterId);
                  }
                  if (lastHideId) {
                      clearTimeout(lastHideId);
                      lastHideId = null;
                  }

                  var $self = $(this);

                  lastFilterId = setTimeout(function() {
                      lastFilterCallback = function() {
                          var searchString = $self.val().trim().toUpperCase(),
                              searchTokens = (searchString.match(/("[^"]+"|[^\s"]+)/g) || []).map(function(current) { return current.replace(/(^"|"$)/g, ""); });

                          var $items = $list.removeClass("hide").children().hide();

                          $.each(searchTokens, function(i, token) {
                              if (token != null) {
                                  $items = $items.filter(function() {
                                      return $(this).text().toUpperCase().indexOf(token) != -1;
                                  });
                              }
                          });

                          $items.show();
                      }

                      if ($list) {
                          lastFilterCallback();
                          lastFilterCallback = null;
                      }

                      lastFilterId = null;
                  }, 350);
              })
              .on("focus", "#breadcrumb-search-box", function() {
                  focused = true;
                  if (!$list) {
                      var $this = $(this).addClass("hrm-textbox-loading"),
                          $target = $this.closest(".hrm-breadcrumb-search");
                      $.post("/Home/BreadcrumbPeopleSearch", function (html) {
                          $this.removeClass("hrm-textbox-loading");
                          $list = $(html).appendTo($target);
                          if (lastFilterCallback) {
                              lastFilterId = setTimeout(lastFilterCallback, 350);
                          }
                      });
                  } else {
                      $list.removeClass("hide");
                  }
              })
              .on("blur", "#breadcrumb-search-box", function () {
                  focused = false;
                  lastHideId = setTimeout(hideCallback, 350);
              })
              .on("mouseover", ".hrm-breadcrumb-search", function() {
                  inBounds = true;
                  if (lastHideId) {
                      clearTimeout(lastHideId);
                      lastHideId = null;
                  }
              })
              .on("mouseout", ".hrm-breadcrumb-search", function() {
                  inBounds = false;
                  lastHideId = setTimeout(hideCallback, 350);
              });
      }());
