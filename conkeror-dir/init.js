// FILE: /home/chu/.conf-scripts/conkeror-dir/init.js
// AUTHOR: Matthew Ball (copyleft 2012)

/// COMMENT: variables
load_paths.unshift("chrome://conkeror-contrib/content/"); // NOTE: load path: allow for 'contrib' stuff
homepage = "http://www.google.com/ig"; // NOTE: homepage
dowload_buffer_automatic_open_target = [OPEN_NEW_BUFFER_BACKGROUND, OPEN_NEW_WINDOW]; // NOTE: open downloads in a new buffer
minibuffer_auto_complete_default = true; // NOTE: auto-completion in the mini-buffer
minibuffer_read_url_select_initial = false; // NOTE: T and O shouldn't keave the URL highlighted
url_completion_use_webjumps = true; // NOTE: complete webjumps
url_completion_use_history = true; // NOTE: should work since (bf05c87405)
url_completion_use_bookmarks = false; // NOTE: bookmarks are now done through webjump
url_remoting_fn = load_url_in_new_buffer; // NOTE: open external links in a new buffer
hints_display_url_panel = true; // NOTE: display properties of the current selected node during the hints interaction
can_kill_last_buffer = false;
view_source_use_external_editor = true; // NOTE: view page source in editor
isearch_keep_selection = true; // NOTE: keep found item selected after search-mode ends

/// COMMENT: MIME types
content_handlers.set("application/pdf", content_handler_save); // NOTE: automatically handle some mime types internally

external_content_handlers.set("application/pdf", "evince");
external_content_handlers.set("application/x-dvi", "evince");

/// COMMENT: mode-line
require("mode-line.js");
require("mode-line-buttons.js");

// add_hook("mode_line_hook", mode_line_adder(current_buffer_name_widget));
add_hook("mode_line_hook", mode_line_adder(loading_count_widget), true); // NOTE: shows how many buffers are currently loading
add_hook("mode_line_hook", mode_line_adder(buffer_count_widget), true); // NOTE: shows how many buffers are currently open
remove_hook("mode_line_hook", mode_line_adder(clock_widget));
// remove_hook("mode_line_hook", mode_line_adder(current_buffer_scroll_position_widget));

mode_line_add_buttons(standard_mode_line_buttons, true);

/// COMMENT: favicons
require("favicon");

add_hook("mode_line_hook", mode_line_adder(buffer_icon_widget), true);
read_buffer_show_icons = true; // NOTE: show favicons in the open buffer completions listing

/// COMMENT: tab-bar mode
// require("new-tabs.js"); // NOTE: show tabs
require("clicks-in-new-buffer.js"); // NOTE: open buffers (tabs) in the background

clicks_in_new_buffer_target = OPEN_NEW_BUFFER_BACKGROUND;
clicks_in_new_buffer_button = 1; // NOTE: middle-click opens links in new buffers

/// COMMENT: webjumps and smartlinks
define_webjump("bookmark", function(term) {return term;},
               $completer = history_completer($use_history = false, $use_bookmarks = true, $match_required = true),
               $description = "Visit a Conkeror bookmark.");

// NOTE: procrastination stuff
define_webjump("fb", "http://www.facebook.com", $description="Facebook");
define_webjump("g+", "http://plus.google.com", $description="Google+");
define_webjump("gi", "http://google.com/ig", $description="iGoogle");
define_webjump("reddit", "http://www.reddit.com", $description="Reddit");
define_webjump("uf", "http://ubuntuforums.org", $description="Ubuntu Forums");
define_webjump("lp", "https://launchpad.net/", $description="Launchpad");
define_webjump("afl", "http://www.afl.com.au", $description="Australian Football League");
define_webjump("modem", "http://gateway.2wire.net", $description="Telstra Modem Information");

// NOTE: mailing lists
define_webjump("orgml", "http://lists.gnu.org/mailman/listinfo/emacs-orgmode", $description="Org-Mode Mailing List");
define_webjump("ircml", "http://lists.ubuntu.com/archives/ubuntu-irc/", $description="Ubuntu IRC Mailing List");
define_webjump("gnuml", "http://lists.gnu.org/mailman/listinfo", $description="GNU Mailing Lists");
define_webjump("ubumla", "http://lists.ubuntu.com/archive/", $description="Ubuntu Mailing Lists Archive");
define_webjump("gnumla", "http://lists.gnu.org/archive/html/", $description="GNU Mailing Lists Archive (Most Recent to Oldest)");

// NOTE: school stuff
define_webjump("pp", "http://philpapers.org", $description="Philosophy Papers");
define_webjump("stanford", "http://plato.stanford.edu/search/searcher.py?query=%s", $alternative="http://plato.stanford.edu", $description="Stanford Encyclopedia of Philosophy");
define_webjump("jstor", "http://www.jstor.org.virtual.anu.edu.au", $description="Journal Storage");
define_webjump("anu", "http://www.anu.edu.au", $description="Australian National University");
define_webjump("library", "http://anulib.anu.edu.au", $description="ANU Library");
define_webjump("wattle", "https://wattle.anu.edu.au", $description="ANU Wattle");
define_webjump("webmail", "https://anumail.anu.edu.au", $description="ANU Webmail");
define_webjump("isis", "https://esapps.anu.edu.au/sscsprod/psp/sscsprod", $description="ANU ISIS and HORUS");
define_webjump("aarnet", "http://www.aarnet.edu.au", $description="Australia's Academic and Reseach Network");

// NOTE: search stuff
define_webjump("youtube", "http://www.youtube.com/results?search_query=%s&search=Search", $alternative="http://www.youtube.com", $description="Search YouTube");
define_webjump("hoogle", "http://haskell.org/hoogle/?hoogle=%s", $alternative="http://haskell.org/hoogle/", $description="Search Hoogle");
define_webjump("org-mode","https://www.google.com/cse?cx=002987994228320350715%3Az4glpcrritm&q=%s&sa=Search&siteurl=orgmode.org%2Fworg", $alternative="http://orgmode.org", $description="Search Org-Mode");
define_webjump("conkerorwiki", "http://conkeror.org/FrontPage?action=fullsearch&context=180&value=%s&titlesearch=Text", $alternative="http://conkeror.org", $description="Search Conkeror Wiki");
define_webjump("stumpwmwiki", "http://stumpwm.svkt.org/cgi-bin/wiki.pl?search=%s&dosearch=Go%21", $alternative="http://stumpwm.antidesktop.net/cgi-bin/wiki.pl", $description="Search StumpWM Wiki");
define_webjump("emacswiki", "http://www.google.com/cse?cx=004774160799092323420%3A6-ff2s0o6yi&q=%s&sa=Search&siteurl=emacswiki.org%2F", $alternative="http://www.emacswiki.org", $description="Search Emacs Wiki");

// NOTE: google specialised searching
define_webjump("scholar", "http://scholar.google.com/scholar?q=%s", $alternative="http://scholar.google.com", $description="Search Google Scholar");
define_webjump("books", "http://www.google.com/search?q=%s&tbm=bks", $alternative="http://books.google.com", $description="Search Google Books");
define_webjump("code", "http://www.code.google.com/query/#q=%s", $alternative="http://www.code.google.com", $description="Search Google Code");
define_webjump("translate", "http://translate.google.com", $description="Google Translate"); // NOTE: there is no search here

// NOTE: ubuntu (and launchpad) specialised search
define_webjump("ubuntupkg", "http://packages.ubuntu.com/%s", $description="Search Ubuntu Packages");
define_webjump("ubuntubugs", "http://bugs.launchpad.net/ubuntu/+source/%s", $description="Search Ubuntu Bugs");
define_webjump("launchpad", "https://launchpad.net/+search?field.text=%s", $description="Search Launchpad");

define_webjump("github", "http://github.com/search?q=%s", $alternative="http://github.com", $description="Search GitHub"); // NOTE: github search
define_webjump("gitorious", "http://gitorious.org/search?q=%s", $alternative="http://gitorious.org", $description="Search Gitorious"); // NOTE: gitorious search

// NOTE: selection searches
// TODO: fix
// function create_selection_search(webjump, key) {
//   interactive(webjump+"-selection-search",
// 	      "Search " + webjump + " with selection contents",
// 	      "find-url-new-buffer",
// 	      $browser_object = function (I) {
// 		return webjump + " " + I.buffer.top_frame.getSelection();
// 	      });
//   define_key(content_buffer_normal_keymap, key.toUpperCase(), webjump + "-selection-search");

//   interactive("prompted-"+webjump+"-search", null,
// 	      function (I) {
// 		var term = yield I.minibuffer.read_url($prompt = "Search "+webjump+":", $initial_value = webjump+" ");
// 		browser_object_follow(I.buffer, FOLLOW_DEFAULT, term);
// 	      });
//   define_key(content_buffer_normal_keymap, key, "prompted-" + webjump + "-search");
// }

// create_selection_search("google","g");
// create_selection_search("wikipedia","w");
// create_selection_search("amazon","a");
// create_selection_search("youtube","y");

read_url_handler_list = [read_url_make_default_webjump_handler("google")]; // NOTE: default webjump

/// COMMENT: quickjumps
interactive("open-gmail", "Open gmail inbox.", "follow-new-buffer", $browser_object = "http://gmail.com/"); // NOTE: open gmail (an alias of the follow-new-buffer command)

interactive("open-school-all","Open school related web-sites.",
	    function(I) {
	      load_url_in_new_buffer("http://wattle.anu.edu.au",I.window); // NOTE: wattle
	      load_url_in_new_buffer("http://anumail.anu.edu.au",I.window); // NOTE: webmail
	    });

/// COMMENT: emacs integration
editor_shell_command = "emacsclient -c"; // NOTE: edit form text with emacs

function org_capture(key, text, window) { // NOTE: org-protocol capture
  var command_string = 'emacsclient \"org-protocol:/capture:/'+key+'/'+text+'\"';
  if (window != null) {
    window.minibuffer.message('Issuing: ' + command_string);
  }
  shell_command_blind(command_string);
}

interactive("bookmark-capture", "Capture a bookmark via org-protocol.",
	    function (I) {
	      var bookmark_url = (yield I.buffer.display_uri_string);
	      var bookmark_title = (yield I.buffer.document.title);
	      var bookmark_string = encodeURIComponent(bookmark_url) + '/' + encodeURIComponent(bookmark_title);
	      org_capture("k", bookmark_string, I.window);
	    });

// FIX: doesn't capture the price ...
interactive("book-capture", "Capture a book via org-protocol.",
	    function (I) {
	      var book_url = (yield I.buffer.display_uri_string);
	      var book_title = (yield I.minibuffer.read($prompt = "Title: "));
	      var book_author = (yield I.minibuffer.read($prompt = "Author: "));
	      // var book_price = (yield I.minibuffer.read($prompt = "Price: "));
	      // var book_string = encodeURIComponent(book_url) + '/' + book_title + '/' + book_author + '/' + book_price;
	      var book_string = encodeURIComponent(book_url) + '/' + book_title + '/' + book_author;
	      org_capture("b", book_string, I.window);
	    });

/// COMMENT: user functions
function echo_message(window, message) {
  window.minibuffer.message(message);
}

function url_completion_toggle (I) {
  if (url_completion_use_bookmarks) {
    url_completion_use_bookmarks = false;
    url_completion_use_history = true;
  } else {
    url_completion_use_bookmarks = true;
    url_completion_use_history = false;
  }
}

interactive("copy-url", "Copy the current buffer's URL to the clipboard.",
	    function(I) {
	      var text = I.window.buffers.current.document.location.href;
	      writeToClipboard(text);
	      I.window.minibuffer.message("copied: " + text);
	    });

interactive("reload-config", "Reload ~/.conkerorrc file.",
	    function(I) {
	      load_rc();
	      I.window.minibuffer.message("Config file reloaded.");
	    });

interactive("url-completion-toggle", "toggle between bookmark and history completion", url_completion_toggle);

// ERROR: this doesn't appear to work
// url_completion_toggle; // NOTE: open only bookmarks by default (toggle to using history with C-c t)

/// COMMENT: download directory
{
  let _save_path = get_home_directory();

  function update_save_path(info) {
    _save_path = info.target_file.parent.path;
  }

  add_hook("download_added_hook", update_save_path);

  suggest_save_path_from_file_name = function (filename, buffer) {
    let file = make_file(_save_path);
    file.append(filename);
    return file.path;
  }
}

/// COMMENT: key bindings
key_bindings_ignore_capslock = true;

define_key(default_global_keymap, "C-c u", "copy-url"); // copy url with C-c u
define_key(default_global_keymap, "C-c r", "reload-config"); // reload config with C-c r
define_key(default_global_keymap, "C-c j", "ns-toggle-temp"); // NOTE: enable javascript
define_key(default_global_keymap, "C-x f", "find-url"); // find url in current buffer with C-x f
define_key(default_global_keymap, "C-x M-f", "find-alternate-url"); // modify url with C-x M-f
define_key(default_global_keymap, "C-x m", "mode-line-mode"); // toggle mode-line with C-x m
define_key(default_global_keymap, "C-w", "kill-region"); // kill region (cut selected text) with C-x w
define_key(content_buffer_normal_keymap, "d", "follow-new-buffer"); // follow link in a new buffer
define_key(content_buffer_normal_keymap, "C-c k", "bookmark-capture"); // capture bookmark with C-c k
define_key(content_buffer_normal_keymap, "C-c b", "book-capture"); // capture book (from amazon) with C-c b
define_key(content_buffer_normal_keymap, "C-c t", "url-completion-toggle"); // url completion with C-c t
define_key(content_buffer_normal_keymap, "f1", "open-school-all"); // open school urls with f1
define_key(content_buffer_normal_keymap, "f2", "open-gmail"); // open gmail inbox with f2

/// COMMENT: xkcd mode
xkcd_add_title = true;

/// COMMENT: wikipedia mode
require("page-modes/wikipedia.js")
wikipedia_enable_didyoumean = true; // automatically follow "did you mean" links on wikipedia search pages

/// COMMENT: reddit mode
require("reddit");

/// COMMENT: auto-hide the mode-line
// var minibuffer_autohide_timer = null;
// var minibuffer_autohide_message_timeout = 3000; //milliseconds to show messages
// var minibuffer_mutually_exclusive_with_mode_line = true;

// function hide_minibuffer (window) {
//   window.minibuffer.element.collapsed = true;
//   if (minibuffer_mutually_exclusive_with_mode_line && window.mode_line)
//     window.mode_line.container.collapsed = false;
// }

// function show_minibuffer (window) {
//   window.minibuffer.element.collapsed = false;
//   if (minibuffer_mutually_exclusive_with_mode_line && window.mode_line)
//     window.mode_line.container.collapsed = true;
// }

// add_hook("window_initialize_hook", hide_minibuffer);
// // for_each_window(hide_minibuffer); // initialize existing windows

// var old_minibuffer_restore_state = (old_minibuffer_restore_state || minibuffer.prototype._restore_state);

// minibuffer.prototype._restore_state = function () {
//   if (minibuffer_autohide_timer) {
//     timer_cancel(minibuffer_autohide_timer);
//     minibuffer_autohide_timer = null;
//   }
//   if (this.current_state)
//     show_minibuffer(this.window);
//   else
//     hide_minibuffer(this.window);
//   old_minibuffer_restore_state.call(this);
// };

// var old_minibuffer_show = (old_minibuffer_show || minibuffer.prototype.show);

// minibuffer.prototype.show = function (str, force) {
//   var w = this.window;
//   show_minibuffer(w);
//   old_minibuffer_show.call(this, str, force);
//   if (minibuffer_autohide_timer)
//     timer_cancel(minibuffer_autohide_timer);
//   minibuffer_autohide_timer = call_after_timeout(
//     function () { hide_minibuffer(w); },
//     minibuffer_autohide_message_timeout);
// };

// var old_minibuffer_clear = (old_minibuffer_clear || minibuffer.prototype.clear);

// minibuffer.prototype.clear = function () {
//   if (minibuffer_autohide_timer) {
//     timer_cancel(minibuffer_autohide_timer);
//     minibuffer_autohide_timer = null;
//   }
//   if (! this.current_state)
//     hide_minibuffer(this.window);
//   old_minibuffer_clear.call(this);
// };

/// COMMENT: google
// register_user_stylesheet(
//   "data:text/css,"+
//   escape(
//     "@-moz-document url-prefix(http://www.google.com/search?)"+
//     "{#leftnav {display: none !important;}"+
//     "#center_col {margin-left: 0px !important;}}"));

/// COMMENT: session
require("session.js");
// session_auto_save_file = "./session"
session_auto_save_auto_load = true; // automatically load saved session on startup
// session_auto_save_auto_load = "prompt";

/// COMMENT: history
session_pref('browser.history_expire_days', 1); // history expires after two days

// NOTE: don't think I will actually need any of the following:
// ----
// define_browser_object_class(
//     "history-url", null,
//     function (I, prompt) {
//         check_buffer (I.buffer, content_buffer);
//         var result = yield I.buffer.window.minibuffer.read_url($prompt = prompt,  $use_webjumps = false, $use_history = true, $use_bookmarks = false);
//         yield co_return (result);
//     });

// interactive("find-url-from-history",
//             "Find a page from history in the current buffer",
//             "find-url",
// 	    $browser_object = browser_object_history_url);

// interactive("find-url-from-history-new-buffer",
//             "Find a page from history in the current buffer",
//             "find-url-new-buffer",
//             $browser_object = browser_object_history_url);

function history_clear () {
    var history = Cc["@mozilla.org/browser/nav-history-service;1"]
        .getService(Ci.nsIBrowserHistory);
    history.removeAllPages();
}

interactive("history-clear", "Clear the history.", history_clear);

// define_key(content_buffer_normal_keymap, "h", "find-url-from-history-new-buffer");
// define_key(content_buffer_normal_keymap, "H", "find-url-from-history");

/// COMMENT: adblock plus
require("adblockplus.js");

/// COMMENT: noscript
require("noscript");

/// COMMENT: daemon
// NOTE: apparently the session module does not work correctly with daemon
// require('daemon');
// daemon_mode(1);
