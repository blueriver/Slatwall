component displayname="File Service" persistent="false" output="false" hint="This is a utility component which handles common file operations" {

	public any function init() {
		return this;
	}

	// Image File Methods
	public string function displayImage(required string imagePath, string width="", string height="",string alt="",string class="") {
		var imageDisplay = "";
		if(!fileExists(expandPath(arguments.imagePath))) {
			arguments.imagePath = "/plugins/Slatwall/images/misc/ImageNotAvailable.jpg";
		}
		if(!len(arguments.width) && !len(arguments.height)) {
			// if no width and height is passed in, display the original image
			var img = imageRead(expandPath(arguments.imagePath));
			imageDisplay = '<img src="#arguments.imagePath#" width="#imageGetWidth(img)#" height="#imageGetHeight(img)#" alt="#arguments.alt#" />';
		} else {
			// if dimensions are passed in, check to see if the image has already been created. If so, display it, if not create it first and then display it
			var imageNameSuffix = (len(arguments.width) && len(arguments.height)) ? "_#arguments.width#w_#arguments.height#h" : (len(arguments.width) ? "_#arguments.width#w" : "_#arguments.height#h");
			var imageExt = listLast(arguments.imagePath,".");
			var resizedImagePath = replaceNoCase(arguments.imagePath,".#imageExt#","#imageNameSuffix#.#imageExt#");
			if(fileExists(expandPath(resizedImagePath))) {
				var img = imageRead(expandPath(resizedImagePath));
			} else {
				var img = imageRead(expandPath(arguments.imagePath));
				// scale to fit if both height and width are specified, else resize accordingly
				if(len(arguments.width) and len(arguments.height)) {
					imageScaleToFit(img,arguments.width,arguments.height);
				} else {
					imageResize(img,arguments.width,arguments.height);
				}
				imageWrite(img,expandPath(resizedImagePath));
			}
			imageDisplay = '<img src="#resizedImagePath#" width="#imageGetWidth(img)#" height="#imageGetHeight(img)#" alt="#arguments.alt#" class="#arguments.class#" />';	
		}
		return imageDisplay;
	}

	public boolean function saveImage(required struct uploadResult, required string filePath, string allowedExtensions="") {
		var result = arguments.uploadResult;
		if(result.fileWasSaved){
			var uploadPath = result.serverDirectory & "/" & result.serverFile;
			var validFile = isImageFile(uploadPath);
			if(len(arguments.allowedExtensions)) {
				validFile = listFind(arguments.allowedExtensions,result.serverFileExt);
			}
			if(validFile) {
				var img=imageRead(uploadPath);
				var absPath = expandPath(arguments.filePath);
				if(!directoryExists(getDirectoryFromPath(absPath))) {
					directoryCreate(getDirectoryFromPath(absPath));
				}
				imageWrite(img,absPath);
				return true;
			} else {
				// file was not a valid image, so delete it
				fileDelete(uploadPath);
				return false;
			}	
		} else {
			// upload was not successful
			return false;
		}
	}
	
	public boolean function removeImage(required string filePath) {
		var fileName = right(arguments.filePath,len(arguments.filePath)-len(getDirectoryFromPath(arguments.filePath)));
		// pop off leading slash
		if(fileName.startsWith("/") or fileName.startsWith("\")) {
			fileName = right(fileName,len(filename)-1);
		}
		// get file name without extension
		var baseFileName = listFirst(fileName,".");
		var fileList = directoryList(expandPath(getDirectoryFromPath(arguments.filePath)),true,"query");
		// loop through directory and delete base image and all resized versions
		for(var i = 1; i<= fileList.recordCount; i++) {
			if(fileList.type[i] == "file" && fileList.name[i].startsWith(baseFileName)) {
				fileDelete(fileList.directory[1] & "/" & fileList.name[i]);
			}
		}
		return true;
	}
	
	
	/*
	*  This function is part of the Common Function Library Project. An open source
	*   collection of UDF libraries designed for ColdFusion 5.0 and higher. For more information,
	*   please see the web site at:
	*
	*       http://www.cflib.org
	*
	*   License:
	*   This code may be used freely.
	*   You may modify this code as you see fit, however, this header, and the header
	*   for the functions must remain intact.
	*
	*   This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
	*
	*  @hint This function will remove any reserved characters from a filename string and replace any spaces with dashes.
	*  @param filename   Filename. (Required)
	*  @return Returns a string. 
	*  @author Jason Sheedy (jason@jmpj.net) 
	*  @version 1, January 19, 2006 (transposed to cfscript for Slatwall Mura plugin by Tony Garcia Feb 2011)
	*/
	
	public string function filterFilename(string filename) {
		var newFileName = "";
		if( structKeyExists(arguments,"filename") && len(arguments.fileName) ) {
		    var filenameRE = "[" & "'" & '"' & "##" & "/\\%&`@~!,:;=<>\+\*\?\[\]\^\$\(\)\{\}\|]";
		    var newfilename = reReplace(arguments.filename,filenameRE,"","all");
		    newfilename = replace(newfilename," ","-","all");
		}
	    
	    return lcase(newfilename);
	}

}