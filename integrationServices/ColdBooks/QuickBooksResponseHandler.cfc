component {

	public any function logResponse(response) {
		var fileobj= fileOpen("C:/testQB.txt", "write" );
		fileWriteLine(fileObj,"#arguments.response#" );
		fileClose(fileobj);
	}
}