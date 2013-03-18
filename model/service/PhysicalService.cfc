/*

    Slatwall - An Open Source eCommerce Platform
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
component extends="HibachiService" accessors="true" output="false" {

	property name="locationService" type="any";
	property name="skuService" type="any";
	property name="stockService" type="any";
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// Physical 
	public any function processPhysical_commit(required any physical) {
		
		// Loop over physical for each location
			// Create a StockAdjustmentIN and StockAdjustmentOUT
			// call getStockService().processStockAdjustment(stockAdjustment=stockAdjustmentIN, processContext="processAdjustment")
			// call getStockService().processStockAdjustment(stockAdjustment=stockAdjustmentOUT, processContext="processAdjustment")
		
	
	}
	
	public any function processPhysical_addPhysicalCount(required any physical, required any processObject) {
		
		// Create a new Physical count
		var physicalCount = this.newPhysicalCount();
		
		var tempDir = getTempDirectory();
		
		// Set the physical for this count
		physicalCount.setPhysical( arguments.physical );
		
		// Set the location for this count
		physicalCount.setLocation( getLocationService().getLocation( arguments.processObject.getLocationID() ));
		
		// Set the count post date time
		physicalCount.setCountPostDateTime( arguments.processObject.getCountPostDateTime() );
		
		// Upload to temp directory
		var documentData = fileUpload( tempDir,'countFile','','makeUnique' );
		var fileName = documentData.serverFile;
		
		// Read the File from temp directory 
		fileObj = fileOpen( "#tempDir##fileName#", "read" ); 
		
		// Loop over the records in the file we just read
		while(!fileIsEof( fileObj )) 
		{ 
			var fileRow = fileReadLine( fileObj ); 
			
			var physicalCountItem = this.newPhysicalCountItem();
			physicalCountItem.setPhysicalCount( physicalCount );
			
			for(var i=1; i<=listLen(fileRow); i=i+1){
			
				// Create a PhysicalCountItem for each row in the file
				physicalCountItem.setSkuCode( listGetAt( fileRow, 1 ) );
				
				// Validate if quantity is numeric
				if( isNumeric(listGetAt( fileRow, 2 ))){
					physicalCountItem.setquantity( listGetAt( fileRow, 2 ) );
				}
				else{
					physicalCountItem.setquantity( "0" );
				}
				
				// Get sku from sku code
				var sku = getSkuService().getSkuBySkuCode( PhysicalCountItem.getSkuCode() );
				
				if( !isNull(sku) ){
					// Get stock by sku and location
					var stock = getStockService().getStockBySkuAndLocation(sku, physicalCount.getLocation());
					
					// Set physical stock from scanned data
					physicalCountItem.setStock( stock );
				}
			}

			// Save each physicalcountitem 
			this.savePhysicalCountItem( physicalCountItem ); 
		} 
		fileClose( fileObj ); 
		
		// Save the physicalCount 
		this.savePhysicalCount( physicalCount );
		
		// Get the assets folder from the global assets folder
		var assetsFileFolderPath = getHibachiScope().setting('globalAssetsFileFolderPath');
		
		// Create the folder if it does not exist 
		if(!directoryExists("#assetsFileFolderPath#/physicalcounts/")) {
			directoryCreate("#assetsFileFolderPath#/physicalcounts/");
		}
		
		// Move a copy of the file from the temp directory to /custom/assets/files/physicalcounts/{physicalCount.getPhysicalCountID()}.txt
		filemove( "#tempDir##fileName#", "#assetsFileFolderPath#/physicalcounts/#physicalCount.getPhysicalCountID()#.txt" );

		// Return the physical that came in from the arguments scope
		return arguments.physical;
	}


	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
	
}