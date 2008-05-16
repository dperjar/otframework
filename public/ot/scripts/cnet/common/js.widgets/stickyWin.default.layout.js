/*	Script: stickyWin.default.layout.js
		Creates an html holder for in-page popups using a default style.
		
		Author:
		Aaron Newton <aaron [dot] newton [at] cnet [dot] com>
		
		Dependencies:
		mootools - <Moo.js>, <Utility.js>, <Common.js>, <Function.js>, <Element.js>, <Array.js>, <String.js>
		cnet - <simple.template.parser.js>
		
		Function: stickyWinHTML
		Returns a DOM element for in-page popups (<stickyWin>) with a default style.
		
		Arguments:
		caption - (string) the caption for the popup window
		body - (string or DOM element) content for the popup
		options - a key/value set of options
		
		Options:
		width - (string) width for the box; defaults to 300px.
		css - (string) override for the css styles for the default html
		cssClass - (string; optional) adds a css class in addition to "DefaultStickyWin" to the container
		baseHref: (string) url to the path where the images in the default style are located.
							defaults to http://www.cnet.com/html/rb/assets/global/stickyWinHTML/.
		buttons - (array) array of key/value set of button options (see below)
		
		Buttons:
		text - (string) the text of the button
		onClick - (function) function to execute on click
		properties - (object) a name/value set of properties applied to the element using <Element.setProperties>
		properties.class - (string) a css class name for the button; defaults to "closeSticky" which closes the popup. You can give a different class name, and the button won't close the sticky when clicked. You can also give it an additional class name (className: 'closeSticky button') so that it will have your additional class but will still close the popup.
		
		Example:
(start code)
stickyWinHTML('the caption', 'this is the body', {
  width: '400px',
	buttons: [
		{
			text: 'close', 
			onClick: function(){alert('closed!')}
		},
		{
			text: 'okey-dokey', 
			onClick: function(){alert('ok!')},
			properties: {class: 'ok'} //don't close though
		},
		{
			text: 'blah', 
			onClick: function(){alert('blah!')},
			properties: {
				class: 'closeSticky blah', //still closes
				style: 'width: 100px, border: 1px solid red',
				title: 'blah! I say!'
			}
		}
	]
});
(end)
		
		Resulting HTML:
		The HTML generated by this function looks like this:
(start code)
<div class="DefaultStickyWin">
	<div class="top">
		<div class="top_ul"></div>
		<div class="top_ur">
			<div class="closeButton closeSticky"></div>
			<h1 style="width: 335px;" class="caption">the caption</h1>
		</div>
	</div>
	<div class="middle">
		<div class="body">this is the body</div>
	</div>
	<div class="closeBody">
		<div class="closeButtons">
			<a class="closeSticky button">close</a>
			<a class="ok button">okey-dokey</a>
			<a class="closeSticky blah button" title="blah! I say!" style="width: 100px, border; 1px solid red">blah</a>
		</div>
	</div>
	<div class="bottom">
		<div class="bottom_ll"></div>
		<div class="bottom_lr"></div>
	</div>
</div>
(end)
	*/
function stickyWinHTML (caption, body, options){
	options = $merge({
		width: '300px',
		css: "div.DefaultStickyWin div.body{font-family:verdana; font-size:11px; line-height: 13px;}"+
			"div.DefaultStickyWin div.top_ul{background:url(%baseHref%full.png) top left no-repeat; height:30px; width:15px; float:left}"+
			"div.DefaultStickyWin div.top_ur{position:relative; left:0px !important; left:-4px; background:url(%baseHref%full.png) top right !important; height:30px; margin:0px 0px 0px 15px !important; margin-right:-4px; padding:0px}"+
			"div.DefaultStickyWin h1.caption{margin:0px 5px 0px 0px; overflow: hidden; padding:0; font-weight:bold; color:#555; font-size:14px; position:relative; top:8px; left:5px; float: left; height: 22px;}"+
			"div.DefaultStickyWin div.middle, div.DefaultStickyWin div.closeBody {background:url(%baseHref%body.png) top left repeat-y; margin:0px 20px 0px 0px !important;	margin-bottom: -3px; position: relative;	top: 0px !important; top: -3px;}"+
			"div.DefaultStickyWin div.body{background:url(%baseHref%body.png) top right repeat-y; padding:8px 30px 8px 0px; margin-left:5px; position:relative; right:-20px}"+
			"div.DefaultStickyWin div.bottom{clear:both}"+
			"div.DefaultStickyWin div.bottom_ll{background:url(%baseHref%full.png) bottom left no-repeat; width:15px; height:15px; float:left}"+
			"div.DefaultStickyWin div.bottom_lr{background:url(%baseHref%full.png) bottom right; position:relative; left:0px !important; left:-4px; margin:0px 0px 0px 15px !important; margin-right:-4px; height:15px}"+
			"div.DefaultStickyWin div.closeButtons{text-align: center; background:url(%baseHref%body.png) top right repeat-y; padding: 0px 30px 8px 0px; margin-left:5px; position:relative; right:-20px}" +
			"div.DefaultStickyWin a.button:hover{background:url(%baseHref%big_button_over.gif) repeat-x}"+
			"div.DefaultStickyWin a.button {background:url(%baseHref%big_button.gif) repeat-x; margin: 2px 8px 2px 8px; padding: 2px 12px; cursor:pointer; border: 1px solid #999 !important; text-decoration:none; color: #000 !important;}"+
			"div.DefaultStickyWin div.closeButton{width:13px; height:13px; background:url(%baseHref%closebtn.gif) no-repeat; position: absolute; right: 0px; margin:10px 15px 0px 0px !important; cursor:pointer}",
		cssClass: '',
		baseHref: 'http://www.cnet.com/html/rb/assets/global/stickyWinHTML/',
		buttons: []
/*	These options are deprecated:		
		closeTxt: false,
		onClose: Class.empty,
		confirmTxt: false,
		onConfirm: Class.empty	*/
	}, options);
	//legacy support
	if(options.confirmTxt) options.buttons.push({text: options.confirmTxt, onClick: options.onConfirm || Class.empty});
	if(options.closeTxt) options.buttons.push({text: options.closeTxt, onClick: options.onClose || Class.empty});

	window.addEvent('domready', function(){
		try {
			if(!$('defaultStickyWinStyle')) {
				var css = simpleTemplateParser.parseTemplate(options.css, options);
				if(window.ie) css = css.replace(new RegExp('png', 'gi'),'gif');
				var styler = new Element('style').setProperty('id','defaultStickyWinStyle').injectInside($$('head')[0]);
				if (!styler.setText.attempt(css, styler)) styler.appendText(css);
			}
		}catch(e){dbug.log('error: %s',e);}
	}.bind(this));

	caption = $pick(caption, '%caption%');
	body = $pick(body, '%body');
	var container = new Element('div').setStyle('width', options.width).addClass('DefaultStickyWin');
	if(options.cssClass) container.addClass(options.cssClass);
	//header
	var h1Caption = new Element('h1').addClass('caption').setStyle('width', (options.width.toInt()-60)+'px');

	if($(caption)) h1Caption.adopt(caption);
	else h1Caption.setHTML(caption);
	
	var bodyDiv = new Element('div').addClass('body');
	if($(body)) bodyDiv.adopt(body);
	else bodyDiv.setHTML(body);
	
	
	container.adopt(
		new Element('div').addClass('top').adopt(
				new Element('div').addClass('top_ul')
			).adopt(
				new Element('div').addClass('top_ur').adopt(
						new Element('div').addClass('closeButton').addClass('closeSticky')
					).adopt(h1Caption)
			)
	);
	//body
	container.adopt(new Element('div').addClass('middle').adopt(bodyDiv));
	//close buttons
	if(options.buttons.length > 0){
		var closeButtons = new Element('div').addClass('closeButtons');
		options.buttons.each(function(button){
			if(button.properties && button.properties.className){
				button.properties['class'] = button.properties.className;
				delete button.properties.className;
			}
			var properties = $merge({'class': 'closeSticky'}, button.properties);
			new Element('a').addEvent('click',
				button.onClick || Class.empty).appendText(
				button.text).injectInside(closeButtons).setProperties(properties).addClass('button');
		});
		container.adopt(new Element('div').addClass('closeBody').adopt(closeButtons));
	}
	//footer
	container.adopt(
		new Element('div').addClass('bottom').adopt(
				new Element('div').addClass('bottom_ll')
			).adopt(
				new Element('div').addClass('bottom_lr')
		)
	);
	return container;
};

/* do not edit below this line */   
/* Section: Change Log 

$Source: /cvs/main/flatfile/html/rb/js/global/cnet.global.framework/common/js.widgets/stickyWin.default.layout.js,v $
$Log: stickyWin.default.layout.js,v $
Revision 1.29  2007/10/23 23:10:26  newtona
added mootools debugger to cvs
new file: setAssetHref.js; enables you to quickly set the location of image assets contained in the framework so you don't use CNET's versions, which can sometimes be slow.

Revision 1.28  2007/09/24 20:55:49  newtona
new file: StickyWin.Ajax - adds ajax support to all stickywin classes (creates new classes, just append .Ajax to any of the existing ones)
updated redball common full to include StickyWin.Ajax
date.picker, product.picker - updated syntax to use Element.empty
form.validator - now passes along the event object to the onFormValidate event so that the form submit event can be stopped if you like
popupdetails - added html response support; you can now return the html you wish to display rather than a json object; only applies to ajax. Also added a cache so that multiple requests are not made for the same url.
stickyWinHTML - ractored so that options are now, you know, *optional*
MooScroller - added support for width option for horizontal scrolling

Revision 1.27  2007/09/15 00:07:08  newtona
collission in last check in; merged and re-doing.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fixed a bug with validate-digits in form validator
new class: TagMaker
implemented TagMaker into simple.editor
updated caption (which is the drag handle for stickyWinHTML) to be the entire width of the caption area
html.table: docs update
tabswapper: docs update

Revision 1.26  2007/08/20 18:11:49  newtona
Iframeshim: better handling for methods when the shim isn't ready
stickyWin: fixed a bug for the cssClass option in stickyWinHTML
html.table: push now returns the dom elements it creates
jsonp: fixed a bug; request no longer requires a url argument (my bad)
Fx.SmoothMove: just tidying up some syntax.
element.dimensions: updated getDimensions method for computing size of elements that are hidden; no longer clones element

Revision 1.25  2007/07/18 16:23:35  newtona
a little style tweaking with stickywin default html

Revision 1.24  2007/07/18 16:15:21  newtona
forgot to bind the style objects in the setText.attempt method...

Revision 1.23  2007/07/16 21:00:21  newtona
using Element.setText for all style injection methods (fixes IE6 problems)
moving Element.setText to element.legacy.js; this function is in Mootools 1.11, but if your environment is running 1.0 you'll need this.

Revision 1.22  2007/07/07 01:26:44  newtona
stickyWinHTML's caption no longer has it's width defined by the width option; it's all css. this means we can resize the box or set the width to 100% or whatever.

Revision 1.21  2007/06/28 23:24:58  newtona
adding some css important rules to stickyWinHTML

Revision 1.20  2007/06/28 23:15:22  newtona
working around a bug in Mootools 1.11: Element.setText

Revision 1.19  2007/06/21 20:08:44  newtona
IE7 ignored the css definition; implemented Element.setText for anyone using Mootools < 1.11 and use that to set the css properties

Revision 1.18  2007/06/07 18:43:37  newtona
added CSS to autocompleter.js
removed string.cnet.js dependencies from template parser and stickyWin.default.layout.js

Revision 1.17  2007/05/17 19:45:43  newtona
product picker: hide() now hides tooltips; onPick passes in a 3rd argument that is the picker
stickyWinHTML: fixed a bug with className options for buttons
html.table: fixed a bug with className options for buttons

Revision 1.16  2007/05/16 20:09:41  newtona
adding new js files to redball.common.full
product.picker.js now has no picklets; these are in the implementations/picklets directory
ProductPicker now detects if there is no doctyp and, if not, sets the position of the picker to be fixed (no IE6 support)
small docs update in element.cnet.js
added new picklet: CNETProductPicker_PricePath
added new picklet: NewsStoryPicker_Path
new file: clipboard.js (allows you to insert text into the OS clipboard)
new file: html.table.js (automates building html tables)
new file: element.forms.js (for managing text inputs - get selected text information, insert content around selection, etc.)

Revision 1.15  2007/05/11 00:10:48  newtona
syntax fix

Revision 1.14  2007/05/07 21:37:12  newtona
docs update

Revision 1.13  2007/05/05 01:01:24  newtona
stickywinHTML: tweaked the options for buttons
element.cnet: tweaked smoothshow/hide css handling

Revision 1.12  2007/05/04 00:32:39  newtona
stickwinHTML: added the ability for buttons to not close the sticky (className option)
stickyWin: added .pin (see Element.pin.js)

Revision 1.11  2007/04/05 00:13:12  newtona
local.vars.js: removing $type.isNumber dependency
login.status.js: no change; fixed typo in docs
search.functions.js: removing $type.isNumber dependency
stickyWinDefaultLayout: infinite buttons!
iframeShim.js: fixed an ie bug that caused it to abort the page

Revision 1.10  2007/03/29 23:12:00  newtona
confirmer now checks for a bg color in IE6 to use crossfading (see Element.fxOpacityOk)
fixed an IE7 css layout issue in stickyDefaultHTML
StickyWin now uses Element.flush
StickyWinFx.Drag now temporarily shows the sticky win (with opacity 0) to execute makeDraggable and makeResizable to prevent a Safari bug

Revision 1.9  2007/03/13 19:09:29  newtona
fixed a typy - added event "close" instead of "click". duh.

Revision 1.8  2007/03/13 18:57:17  newtona
syntax fix

Revision 1.7  2007/03/13 18:49:56  newtona
added onClose action

Revision 1.6  2007/03/08 02:38:50  newtona
added close and confirm buttons

Revision 1.5  2007/03/02 01:31:53  newtona
fixed some css bugs in IE
fixed a bug where all blocks inherited the width of the first created

Revision 1.4  2007/02/24 00:21:56  newtona
fixed  a css bug

Revision 1.3  2007/02/22 21:27:43  newtona
moved product picker from utilities dir
fixed missing ; in stickywin html

Revision 1.2  2007/02/22 18:19:48  newtona
fixed a bug with the style writer
added a missing bind()

Revision 1.1  2007/02/21 00:41:48  newtona
*** empty log message ***


*/