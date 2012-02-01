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
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	property name="orderService" type="any";

	public void function parseCommentAndCreateRelationships(required any comment) {
		var wordArray = listToArray(arguments.comment.getComment(), " ");
		for(var i=1; i<=arrayLen(wordArray); i++) {
			if(wordArray[i] == "order" || wordArray[i] == "orderNumber" || wordArray[i] == "orderNo" || wordArray[i] == "orderNo." || wordArray[i] == "order##") {
				var x = 0;
				do {
					x++;
					var thisValue = reReplace(wordArray[i+x], "[^0-9]", "", "all");
					if(isNumeric(thisValue) && thisValue > 0) {
						var order = getOrderService().getOrderByOrderNumber(orderNumber=thisValue);
						if(!isNull(order)) {
							arguments.comment.addOrder( order );
						}
					}
				} while (x < 4);
			}
		}
	}
	
	public any function saveComment(required any comment, required any data) {
		arguments.comment.populate( arguments.data );
		
		parseCommentAndCreateRelationships( arguments.comment );
		
		arguments.comment.validate("save");
		
		// If the object passed validation then call save in the DAO, otherwise set the errors flag
        if(!arguments.comment.hasErrors()) {
            arguments.comment = getDAO().save(target=arguments.comment);
        } else {
            getService("requestCacheService").setValue("ormHasErrors", true);
        }
        
        return arguments.comment;
	}
	
}
