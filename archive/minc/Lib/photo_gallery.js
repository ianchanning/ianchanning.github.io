var m_picNum;
var m_maxVal;
var m_maxThumb;
var m_strPicPath;
var m_picArray;

/*
* DATE: 01 Dec 2004
* PRE:	An HTML form with id="gallery" must exist.  This is the initialisation function, it is called onLoad.
*		Also the module level array of descriptions for each Picture must have been created.
* POST:	Sets the thumbnails number description as well as the text for the initial main image.
*/
function myGallery( picNum, maxVal, maxThumb, strPicPath, picArray )
{
	m_picNum = picNum;
	m_maxVal = maxVal;
	m_maxThumb = maxThumb;
	m_strPicPath = strPicPath;
	m_picArray = picArray;
	//alert( m_picNum + "|" + m_maxVal + "|" + m_maxThumb + "|" + m_strPicPath );
	setMyNumber();

	/*

	--We're not using this for now...


	document.gallery.mytext.value = '!';
	if (m_picArray[m_picNum-1] != null)
	{
		document.gallery.mytext.value = m_picArray[m_picNum-1];
	}
	*/
}

/*
* DATE: 01 Dec 2004
* PRE:	Takes an integer of how far to navigate through the thumbnail collection, e.g. 4 at-a-time, 1 at-a-time etc.
* POST:	Advances each thumbnail in the gallery by the intNav.
*/
function picThumbNav(intNav)
{
	m_picNum = getPicIndex(m_picNum + intNav);

	for( var i = 0; i < m_maxThumb; i++ )
	{
		selectThumb(getPicIndex(m_picNum + i), i);
	}

	setMyNumber();
}

/*
* DATE: 01 Dec 2004
* PRE:	Takes an integer of how far to navigate through the main image collection, e.g. 1 at-a-time etc.
* POST:	Gets the main image number and advances by the intNav.
*/
function picMainNav(intNav)
{
	var strSrc = document.images['picMain'].src;

	//the image source will be of the following structure: photo001.jpg, we want to extract the '001'.
	var intPic = parseInt(strSrc.substring(strSrc.lastIndexOf('.') - 3, strSrc.lastIndexOf('.')), 10);

	selectMain(getPicIndex(intPic + intNav));
}

/*
* DATE: 01 Dec 2004
* PRE: 	intThumb signifies which gallery thumbnail has been clicked.
* POST:	uses intThumb as an offset from the current picNum.
*/
function setMainPicFromThumb(intThumb)
{
	selectMain(getPicIndex(m_picNum + intThumb));
}

/*
* DATE: 01 Dec 2004
* PRE:	Both the image and which thumb in the gallery is to be given the image is passed in.
*		The thumbnail images must have ids of the type 'picSm#' so that they can be identified.
* POST:	The intPic is converted from a number to a thumb image source
*		The intThumb in the thumb collection is given the image source.
*/
function selectThumb(intPic, intThumb)
{
	var strPicNum = formatPicIndex(intPic);

	document.images['picSm' + intThumb].src = m_strPicPath + strPicNum + 'sm.jpg';
}

/*
* DATE: 01 Dec 2004
* PRE:	Similar to selectThumb function.  The image id to be displayed is passed in.
* POST:	The intPic is turned into a source of a main image in the images folder.
*		The main image's source is updated as well as the image number.
*/
function selectMain(intPic)
{
	var strPicNum = formatPicIndex(intPic);

	document.images['picMain'].src = m_strPicPath + strPicNum + '.jpg';
	document.getElementById('galMainDesc').innerHTML = strPicNum;
}

/*
* DATE: 01 Dec 2004
* PRE:	A possible image id is passed in as an integer.
* POST:	Captures overflows outside the correct range which is 1 - m_maxVal.
*/
function getPicIndex(intPic)
{
	//to prevent intPic being -ve, but maxVal will be removed when % is applied.
	var intPicIndex = intPic + m_maxVal;

	//have to make sure that we are staying in the range 1 - maxVal,
	//rather than 0 - (maxVal-1) which is what % gives you
	intPicIndex = ((intPicIndex - 1) % m_maxVal) + 1;

	return intPicIndex;
}

/*
* DATE: 01 Dec 2004
* PRE:	The correct HTML elements exist.
* POST:	Sets the location description of where in the thumbnail collection we are e.g. "001 - 004 of 30"
*/
function setMyNumber()
{
	var intToPicNum = getPicIndex(m_picNum + (m_maxThumb - 1));
	//-- old way: document.gallery.mynumber.value = m_picNum + ' - ' + intToPicNum + ' of ' + m_maxVal;
	document.getElementById('galThumbDesc').innerHTML = formatPicIndex(m_picNum) + ' - ' + formatPicIndex(intToPicNum) + ' of ' + m_maxVal;
}

/*
* DATE: 01 Dec 2004
* PRE:	Takes an integer that is less than 100
* POST:	Adds leading zeros to make it three digits long.
*/
function formatPicIndex(intUnformatted)
{
	var strFormatted;

	if(intUnformatted < 10)
	{
		strFormatted = "00" + intUnformatted;
	}
	else
	{
		strFormatted = "0" + intUnformatted;
	}
	return strFormatted;
}
