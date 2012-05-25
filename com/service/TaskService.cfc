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
component extends="BaseService" output="false" accessors="true"{

	public void function executeTask( required any taskID, required any TaskScheduleID) {
		//Pass in id's and not complex objects like entities. thread doesnt like that

		 thread
			action="run"
			name="myThread"
			taskID="#arguments.taskID#"
			taskScheduleID="#arguments.TaskScheduleID#"
			{
				var taskResponse = "";
				var taskHistory = new('TaskHistory');
				var task = get('Task',attributes.taskID);
				var taskSchedule = get('TaskSchedule',attributes.taskScheduleID);
				
				task.setRunningFlag(true);
				taskHistory.setStartTime(now());
				
				ormFlush();
		
				try{
					if( task.getTaskMethod() == "url") {
						taskResponse = url( task.getTaskURL() );
					} else {
						taskResponse = this.invokeMethod( task.getTaskMethod() );
					}
					taskHistory.setsuccessFlag(true);
					taskHistory.setResponse(taskResponse);
					sendNotificationEmail(taskSchedule,'Success');
					
				} catch(any e){
					taskHistory.setsuccessFlag(false);
					taskHistory.setResponse(e.Message);
					sendNotificationEmail(taskSchedule,'Failed',e);
				}
				
				task.setRunningFlag(false);
				taskHistory.setEndTime(now());
				taskHistory.setTask(task);
				
				if(val(attributes.taskScheduleID)){
					var taskSchedule = get('TaskSchedule',attributes.taskScheduleID);
					schedule = taskSchedule.getSchedule();
					TaskSchedule.setNextRunDateTime(schedule.getNextRunDateTime(TaskSchedule.getStartDateTime(),TaskSchedule.getEndDateTime()));
				}
				
				save(taskHistory);
				ormFlush();
			}	
			
        } 
	
	public void function sendNotificationEmail(required any taskSchedule, required string status, any error){
		
		var mail=new mail();
		mail.setSubject(arguments.status & ': ' & arguments.taskSchedule.getTask().getTaskName());

		mail.setFrom(setting('globalOrderPlacedEmailFrom'));
		mail.setType('HTML');

		if(arguments.status eq "Failed"){
			savecontent variable="errorString" { writedump(var="#arguments.error#" top="2"); };
		
			mail.setTo(arguments.taskSchedule.getFailureEmailList());
			mail.addPart( type="html", charset="utf-8", body="<p>The #arguments.taskSchedule.getTask().getTaskName()# task failed on <i>#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(),"medium")#</i></p><h2>Error Details</h2>#arguments.error.cause.message#" & errorString );
			mail.setBody( "<p>The #arguments.taskSchedule.getTask().getTaskName()# task failed on <i>#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(),"medium")#</i></p><h2>Error Details</h2>#arguments.error.cause.message#" & errorString );
		}else{
			mail.setTo(arguments.taskSchedule.getSuccessEmailList());
			mail.addPart( type="html", charset="utf-8", body="<p>The #arguments.taskSchedule.getTask().getTaskName()# task completed successfully on <i>#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(),"medium")#</i></p>" );
			mail.setBody( "<p>The #arguments.taskSchedule.getTask().getTaskName()# task completed successfully on <i>#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(),"medium")#</i></p>" );
		}
		
		mail.send();

	}
	
	
	// ================== Start: Task Methods ============================
	
	public any function url( required string url ) {
		var response = {};
		// Call CFHTTP for a URL
		
		return response;
	}
	
	public any function renewSubscriptionUsage() {
		var response = '';
		// Do Logic
		var subscriptionUsages = getService("subscriptionService").getDAO().getSubscriptionUsageForRenewal();
		for(var subscriptionUsage in subscriptionUsages) {
			getService("subscriptionService").processSubscriptionUsage(subscriptionUsage, {}, 'autoRenew');
		}
		
		return response;
	}
	
}