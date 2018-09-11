<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>

		<link rel="stylesheet" href="/assets/plugins/bootstrap/css/bootstrap.min.css">

		<link rel="stylesheet" href="/assets/plugins/font-awesome/css/font-awesome.min.css">

		<link rel="stylesheet" href="/assets/fonts/style.css">

		<link rel="stylesheet" href="/assets/css/main.css">

		<link rel="stylesheet" href="/assets/css/main-responsive.css">

		<link rel="stylesheet" href="/assets/plugins/iCheck/skins/all.css">

		<link rel="stylesheet" href="/assets/plugins/bootstrap-colorpalette/css/bootstrap-colorpalette.css">

		<link rel="stylesheet" href="/assets/plugins/perfect-scrollbar/src/perfect-scrollbar.css">

		

		<link rel="stylesheet" href="/assets/less/styles_blue.less" id="skin_color">

		<link rel="stylesheet" href="/assets/css/print.css" type="text/css" media="print"/>
<style>
ul,li,i{font-size:1.4em;float: left; min-width: 400px; min-height: 50px;}
	
</style>

</head>

<body>

<cfset clipList = ".clip-settings, .clip-camera, .clip-tag, .clip-bulb, .clip-paperplane, .clip-bubble, .clip-banknote, .clip-music, .clip-data, .clip-t-shirt, .clip-clip, .clip-calendar, .clip-vynil, .clip-truck, .clip-note, .clip-world, .clip-key, .clip-pencil, .clip-pencil-2, .clip-images, .clip-images-2, .clip-list, .clip-earth, .clip-pictures, .clip-cog, .clip-home, .clip-home-2, .clip-pencil-3, .clip-images-3, .clip-eyedropper, .clip-droplet, .clip-droplet-2, .clip-image, .clip-music-2, .clip-camera-2, .clip-camera-3, .clip-headphones, .clip-headphones-2, .clip-gamepad, .clip-podcast, .clip-connection, .clip-connection-2, .clip-new, .clip-book, .clip-file, .clip-file-2, .clip-file-plus, .clip-file-minus, .clip-file-check, .clip-file-remove, .clip-file-3, .clip-copy, .clip-copy-2, .clip-copy-3, .clip-copy-4, .clip-paste, .clip-stack, .clip-stack-2, .clip-folder, .clip-folder-upload, .clip-folder-download, .clip-folder-remove, .clip-folder-plus, .clip-folder-2, .clip-folder-open, .clip-cc, .clip-tag-2, .clip-barcode, .clip-cart, .clip-phone-hang-up, .clip-phone, .clip-phone-2, .clip-location, .clip-compass, .clip-map, .clip-alarm, .clip-clock, .clip-history, .clip-stopwatch, .clip-keyboard, .clip-screen, .clip-laptop, .clip-mobile, .clip-mobile-2, .clip-tablet, .clip-mobile-3, .clip-rotate, .clip-rotate-2, .clip-redo, .clip-undo, .clip-database, .clip-bubble-2, .clip-bubbles, .clip-bubble-3, .clip-bubble-4, .clip-bubble-dots, .clip-bubble-dots-2, .clip-bubbles-2, .clip-bubbles-3, .clip-user, .clip-users, .clip-user-plus, .clip-user-minus, .clip-user-cancel, .clip-user-block, .clip-user-2, .clip-user-3, .clip-users-2, .clip-user-4, .clip-user-5, .clip-hanger, .clip-quotes-left, .clip-quotes-right, .clip-busy, .clip-spinner, .clip-spinner-2, .clip-spinner-3, .clip-spinner-4, .clip-spinner-5, .clip-spinner-6, .clip-microscope, .clip-search, .clip-zoom-in, .clip-zoom-out, .clip-search-2, .clip-key-2, .clip-key-3, .clip-keyhole, .clip-wrench, .clip-wrench-2, .clip-cog-2, .clip-cogs, .clip-health, .clip-stats, .clip-inject, .clip-bars, .clip-rating, .clip-rating-2, .clip-rating-3, .clip-leaf, .clip-balance, .clip-atom, .clip-atom-2, .clip-lamp, .clip-remove, .clip-puzzle, .clip-puzzle-2, .clip-cube, .clip-cube-2, .clip-pyramid, .clip-puzzle-3, .clip-puzzle-4, .clip-clipboard, .clip-switch, .clip-list-2, .clip-list-3, .clip-list-4, .clip-list-5, .clip-list-6, .clip-grid, .clip-grid-2, .clip-grid-3, .clip-grid-4, .clip-grid-5, .clip-grid-6, .clip-menu, .clip-menu-2, .clip-circle-small, .clip-tree, .clip-menu-3, .clip-menu-4, .clip-cloud, .clip-download, .clip-upload, .clip-download-2, .clip-upload-2, .clip-globe, .clip-upload-3, .clip-download-3, .clip-earth-2, .clip-network, .clip-link, .clip-link-2, .clip-link-3, .clip-link-4, .clip-attachment, .clip-attachment-2, .clip-eye, .clip-eye-2, .clip-windy, .clip-bookmark, .clip-bookmark-2, .clip-brightness-high, .clip-brightness-medium, .clip-star, .clip-star-2, .clip-star-3, .clip-star-4, .clip-star-5, .clip-star-6, .clip-heart, .clip-thumbs-up, .clip-thumbs-up-2, .clip-cursor, .clip-stack-empty, .clip-question, .clip-notification, .clip-notification-2, .clip-question-2, .clip-plus-circle, .clip-plus-circle-2, .clip-minus-circle, .clip-minus-circle-2, .clip-info, .clip-info-2, .clip-cancel-circle, .clip-cancel-circle-2, .clip-checkmark-circle, .clip-checkmark-circle-2, .clip-close, .clip-close-2, .clip-close-3, .clip-checkmark, .clip-checkmark-2, .clip-close-4, .clip-wave, .clip-wave-2, .clip-arrow-up-left, .clip-arrow-up, .clip-arrow-up-right, .clip-arrow-right, .clip-arrow-down-right, .clip-arrow-down, .clip-arrow-down-left, .clip-arrow-left, .clip-arrow-up-left-2, .clip-arrow-up-2, .clip-arrow-up-right-2, .clip-arrow-right-2, .clip-arrow-down-right-2, .clip-arrow-down-2, .clip-arrow-down-left-2, .clip-arrow-left-2, .clip-arrow, .clip-arrow-2, .clip-arrow-3, .clip-arrow-4, .clip-arrow-up-3, .clip-arrow-right-3, .clip-arrow-down-3, .clip-arrow-left-3, .clip-checkbox-unchecked, .clip-checkbox, .clip-checkbox-checked, .clip-checkbox-unchecked-2, .clip-square, .clip-checkbox-partial, .clip-checkbox-partial-2, .clip-checkbox-checked-2, .clip-checkbox-unchecked-3, .clip-radio-checked, .clip-radio-unchecked, .clip-circle, .clip-circle-2, .clip-new-tab, .clip-popout, .clip-embed, .clip-code, .clip-seven-segment-0, .clip-seven-segment-1, .clip-seven-segment-2, .clip-seven-segment-3, .clip-seven-segment-4, .clip-seven-segment-5, .clip-seven-segment-6, .clip-seven-segment-7, .clip-seven-segment-8, .clip-seven-segment-9, .clip-share, .clip-google, .clip-google-plus, .clip-facebook, .clip-twitter, .clip-feed, .clip-youtube, .clip-youtube-2, .clip-vimeo, .clip-flickr, .clip-picassa, .clip-dribbble, .clip-forrst, .clip-deviantart, .clip-steam, .clip-github, .clip-github-2, .clip-wordpress, .clip-blogger, .clip-tumblr, .clip-yahoo, .clip-tux, .clip-apple, .clip-finder, .clip-android, .clip-windows, .clip-windows8, .clip-soundcloud, .clip-skype, .clip-reddit, .clip-linkedin, .clip-lastfm, .clip-stumbleupon, .clip-stackoverflow, .clip-pinterest, .clip-xing, .clip-foursquare, .clip-paypal, .clip-paypal-2, .clip-libreoffice, .clip-file-pdf, .clip-file-openoffice, .clip-file-word, .clip-file-excel, .clip-file-zip, .clip-file-powerpoint, .clip-file-xml, .clip-file-css, .clip-html5, .clip-css3, .clip-chrome, .clip-firefox, .clip-IE, .clip-opera, .clip-safari, .clip-IcoMoon, .clip-fullscreen-exit-alt, .clip-fullscreen, .clip-fullscreen-alt, .clip-fullscreen-exit, .clip-transfer, .clip-left-quote, .clip-right-quote, .clip-heart-2, .clip-study, .clip-wand, .clip-zoom-in-2, .clip-zoom-out-2, .clip-search-3, .clip-user-6, .clip-users-3, .clip-archive, .clip-keyboard-2, .clip-paperclip, .clip-home-3, .clip-chevron-up, .clip-chevron-right, .clip-chevron-left, .clip-chevron-down, .clip-error, .clip-add, .clip-minus, .clip-alert, .clip-pictures-2, .clip-atom-3, .clip-eyedropper-2, .clip-warning, .clip-expand, .clip-clock-2, .clip-target, .clip-loop, .clip-refresh, .clip-spin-alt, .clip-exit, .clip-enter, .clip-locked, .clip-unlocked, .clip-arrow-5, .clip-music-3, .clip-droplet-3, .clip-credit, .clip-phone-3, .clip-phone-4, .clip-map-2, .clip-clock-3, .clip-calendar-2, .clip-calendar-3, .clip-pie, .clip-airplane, .clip-tree-2, .clip-sun, .clip-bubble-paperclip" />
<cfoutput>
<cfloop list="#clipList#" delimiters="," index="_x">
	<ul class="main-navigation-menu">
		<li>
			<i class="#trim(replace(_x, '.', ''))#">#_x#</i>
		</li>
	</ul>	
</cfloop>
</cfoutput>
</body>
</html>