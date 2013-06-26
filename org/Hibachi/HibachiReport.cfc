component accessors="true" persistent="false" output="false" extends="HibachiObject" {
	
	property name="entityName";
	
	// Date Fields
	property name="startDateTime";
	property name="endDateTime";
	property name="dateTimeGroup"; // second, minute, hour, day, week, month, year
	
	property name="data";
	property name="dataHeader";
	
	public any function getData() {
		return ormGetSession().createCriteria('SlatwallOrder');
	}
}