      (function() {
          
        document.domain = 'ipcortex.co.uk';
	var curHeight = 0;
	var curScroll = 0;


        function postUp(msg) {
          if (parent) {
            parent.postMessage(msg, document.referrer);
          }
        }

        function clickPostLink(e) {
          var postId = e.target.getAttribute('data-link-to-post');
          if (postId) {
            var postElement = document.getElementById('post-' + postId);
            if (postElement) {
              var rect = postElement.getBoundingClientRect();
              if (rect && rect.top) {
                postUp({type: 'discourse-scroll', top: rect.top});
                e.preventDefault();
                return false;
              }
            }
          }
        }

	ipc$$winResize = function () {
	  var s = (window.pageYOffset) ? window.pageYOffset : document.body.scrollTop;
	  if( document['body'].offsetHeight == curHeight && s == curScroll)
	    return;
          else
            curHeight = document['body'].offsetHeight;
          // Send a post message with our loaded height
          postUp({type: 'discourse-resize', height: curHeight});
          postUp({type: 'discourse-scroll', top:(curScroll = s)});

          var postLinks = document.querySelectorAll("a[data-link-to-post]"),
              i;

          for (i=0; i<postLinks.length; i++) {
            postLinks[i].onclick = clickPostLink;
          }

          // Make sure all links in the iframe point to _blank
          var cookedLinks = document.querySelectorAll('.cooked a');
          for (i=0; i<cookedLinks.length; i++) {
            cookedLinks[i].target = "_blank";
          }

          // Adjust all names
          var names = document.querySelectorAll('.username a');
          for (i=0; i<names.length; i++) {
            var username = names[i].innerHTML;
            if (username) {
              names[i].innerHTML = new BreakString(username).break();
            }
          }

        };

      })();
