/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="File Service" persistent="false" output="false" hint="This is a utility component which handles common file operations" {

	public any function init() {
		return this;
	}
	
	// Image File Methods
	public string function getResizedImagePath(required string imagePath, numeric width=0, numeric height=0) {
		var resizedImagePath = "";
		if(!fileExists(expandPath(arguments.imagePath))) {
			arguments.imagePath = "/plugins/Slatwall/assets/images/missingimage.jpg";
		}
		if(!arguments.width && !arguments.height) {
			// if no width and height is passed in, display the original image
			resizedPath = arguments.imagePath;
		} else {
			// if dimensions are passed in, check to see if the image has already been created. If so, display it, if not create it first and then display it
			var imageNameSuffix = (arguments.width && arguments.height) ? "_#arguments.width#w_#arguments.height#h" : (arguments.width ? "_#arguments.width#w" : "_#arguments.height#h");
			var imageExt = listLast(arguments.imagePath,".");
			var resizedImagePath = replaceNoCase(arguments.imagePath,".#imageExt#","#imageNameSuffix#.#imageExt#");
			if(!fileExists(expandPath(resizedImagePath))) {
				var img = imageRead(expandPath(arguments.imagePath));
				// scale to fit if both height and width are specified, else resize accordingly
				if(arguments.width && arguments.height) {
					imageScaleToFit(img,arguments.width,arguments.height);
				} else {
					if(!arguments.width) {
						arguments.width = "";
					} else if(!arguments.height) {
						arguments.height = "";
					}
					imageResize(img,arguments.width,arguments.height);
				}
				imageWrite(img,expandPath(resizedImagePath));
			}
		}
		return resizedImagePath;
	}
	
	public string function displayImage(required string imagePath, numeric width=0, numeric height=0,string alt="",string class="") {
		var resizedImagePath = getResizedImagePath(imagePath=arguments.imagePath, width=arguments.width, height=arguments.height);
		var img = imageRead(expandPath(resizedImagePath));
		var imageDisplay = '<img src="#resizedImagePath#" width="#imageGetWidth(img)#" height="#imageGetHeight(img)#" alt="#arguments.alt#" class="#arguments.class#" />';
		return imageDisplay;
	}

	public boolean function saveImage(required struct uploadResult, required string filePath, string allowedExtensions="", boolean overwrite=true) {
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
				imageWrite(img,absPath,arguments.overwrite);
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

	public void function duplicateDirectory(required string source, required string destination, boolean overwrite=false, boolean recurse=true, string nameExclusionList='' ){
		if(isNull(arguments.baseSourceDir)){
			var baseSourceDir = source;
		}
		var dirList = directoryList(arguments.source,false,"query");
		for(var i = 1; i <= dirList.recordCount; i++){
			if(dirList.type[i] == "File" && !listFindNoCase(arguments.nameExclusionList,dirList.name[i])){
				var copyFrom = "#dirList.directory[i]#/#dirList.name[i]#";
				var copyTo = "#arguments.destination##replace(dirList.directory[i],baseSourceDir,'')#/#dirList.name[i]#";
				copyFile(copyFrom,copyTo,arguments.overwrite);
			} else if(dirList.type[i] == "Dir" && arguments.recurse && !listFindNoCase(arguments.nameExclusionList,dirList.name[i])){
				duplicateDirectory(source="#dirList.directory[i]#/#dirList.name[i]#",destination=arguments.destination,overwrite=arguments.overwrite,arguments.recurse=recurse,nameExclusionList=arguments.nameExclusionList,baseSourceDir=baseSourceDir);
			}
		}
	}
	
	private void function copyFile(required string source, required string destination, boolean overwrite=false){
		var destinationDir = getdirectoryFromPath(arguments.destination);
		//create directory
		if(!directoryExists(destinationDir)){
			directoryCreate(destinationDir);
		}
		//copy file if it doens't exist in destination
		if(arguments.overwrite || !fileExists(arguments.destination)) {
			fileCopy(arguments.source,arguments.destination);
		}
	}

}
