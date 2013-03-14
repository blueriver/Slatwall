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

	property name="physicalService" type="any";
	
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
		
		// Set the physical for this count
		physicalCount.setPhysical( arguments.physical );
		
		// Set the count post date time
		physicalCount.setCountPostDateTime( arguments.processObject.getCountPostDateTime() );
		
		// Upload to temp directory
		var documentData = fileUpload(getTempDirectory(),'countFile','','makeUnique');
		
		// Read the File from temp directory 
		fileObj = FileOpen( "#getTempDirectory()##documentData.SERVERFILE#", "read" ); 
		
		// loop over the records in the file we just read
		while(NOT FileIsEOF( fileObj )) 
		{ 
			x = FileReadLine( fileObj ); 
			
			var physicalCountItem = this.newPhysicalCountItem();
			physicalCountItem.setPhysicalCount( physicalCount );
			
			For (i=1;i LTE ListLen(x); i=i+1){
			
				// create a PhysicalCountItem for each row in the file
				physicalCountItem.setSkuCode( ListGetAt(x, 1) );
				physicalCountItem.setquantity( ListGetAt(x, 2) );
			}

			// save each physicalcountitem 
			this.savePhysicalCountItem(physicalCountItem); 
		} 
		fileClose( fileObj ); 
		
		// Save the physicalCount 
		this.savePhysicalCount(physicalCount);
		
		// Move a copy of the file from the temp directory to /custom/assets/files/physicalcounts/{physicalCount.getPhyscialCountID()}.txt
		//filemove( "#getTempDirectory()##documentData.SERVERFILE#", "/custom/assets/files/physicalcounts/#physicalCount.getPhyscialCountID()#.txt");
		
		// return the physical that came in from the arguments scope.
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